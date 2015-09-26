class Api::TripInvitesController < ApplicationController

  respond_to :json
  before_filter :find_trip
  before_filter :authenticate_user!, only: [:create]
  before_filter :authorize, only: [:create]

  def index

  end

  def create
    invited_user = User.find(params[:user_id]) rescue nil
    render json: {success: false} and return if invited_user.blank? || @trip.include_user(invited_user)

    trip_invite = Travels::TripInvite.create(inviting_user: current_user, invited_user: invited_user, trip: @trip)
    render json: {success: trip_invite.persisted?}
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    head 404 and return if @trip.blank?
  end

  def authorize
    head 403 and return if !@trip.include_user(current_user)
  end

end