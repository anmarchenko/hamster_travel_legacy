class MessagesController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :find_trip_invite, only: [:update, :destroy]
  before_filter :authorize!, only: [:update, :destroy]

  def index
    render json: {invites: current_user.incoming_invites.includes(:inviting_user, :trip).limit(10)}
  end

  def destroy
    res = @trip_invite.destroy
    render json: {success: res.destroyed?}
  end

  def update
    trip = @trip_invite.trip
    trip.users << @trip_invite.invited_user
    res = trip.save
    res = @trip_invite.destroy if res
    render json: {success: res.destroyed?}
  end

  private

  def find_trip_invite
    @trip_invite = Travels::TripInvite.where(id: params[:id]).includes(:trip, :invited_user).first
    head 404 and return if @trip_invite.blank?
  end

  def authorize!
    head 403 and return if @trip_invite.invited_user != current_user
  end

end