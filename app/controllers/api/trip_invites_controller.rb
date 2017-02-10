# frozen_string_literal: true
class Api::TripInvitesController < ApplicationController
  respond_to :json

  before_action :find_trip
  before_action :authenticate_user!
  before_action :authorize
  before_action :authorize_destroy, only: [:destroy]

  def create
    invited_user = begin
                     User.find(params[:user_id])
                   rescue
                     nil
                   end
    render(json: { success: false }) && return if invited_user.blank? || @trip.include_user(invited_user)

    trip_invite = Travels::TripInvite.create(inviting_user: current_user, invited_user: invited_user, trip: @trip)
    render json: { success: trip_invite.persisted? }
  end

  def destroy
    if params[:trip_invite_id].present?
      trip_invite = @trip.pending_invites.where(invited_user: params[:trip_invite_id]).first
      head(404) && return if trip_invite.blank?
      trip_invite.destroy
    elsif params[:user_id].present?
      user = @trip.users.find(params[:user_id])
      @trip.users.delete(user)
      @trip.save
    end
    head 200
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    head(404) && return if @trip.blank?
  end

  def authorize
    head(403) && return unless @trip.include_user(current_user)
  end

  def authorize_destroy
    head(403) && return if @trip.author_user != current_user || params[:user_id].to_s == @trip.author_user.id.to_s
  end
end
