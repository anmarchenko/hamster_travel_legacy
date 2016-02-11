class Api::TripInvitesController < ApplicationController

  respond_to :json

  before_filter :find_trip
  before_filter :authenticate_user!
  before_filter :authorize
  before_filter :authorize_destroy, only: [:destroy]

  def create
    invited_user = User.find(params[:user_id]) rescue nil
    render json: {success: false} and return if invited_user.blank? || @trip.include_user(invited_user)

    trip_invite = Travels::TripInvite.create(inviting_user: current_user, invited_user: invited_user, trip: @trip)
    render json: {success: trip_invite.persisted?}
  end

  def destroy
    if params[:trip_invite_id].present?
      trip_invite = @trip.pending_invites.where(invited_user: params[:trip_invite_id]).first
      head 404 and return if trip_invite.blank?
      trip_invite.destroy
    elsif params[:user_id].present?
      user = @trip.users.where(id: params[:user_id]).first
      @trip.users.delete(user)
      @trip.save
    end
    head 200
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    head 404 and return if @trip.blank?
  end

  def authorize
    head 403 and return if !@trip.include_user(current_user)
  end

  def authorize_destroy
    head 403 and return if @trip.author_user != current_user || params[:user_id] == @trip.author_user.id
  end

end