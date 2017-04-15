# frozen_string_literal: true

module Api
  class TripInvitesController < Api::BaseController
    respond_to :json

    before_action :find_trip
    before_action :authenticate_user!
    before_action :authorize
    before_action :authorize_destroy, only: [:destroy]

    def create
      invited_user = User.find(params[:user_id])
      if @trip.include_user(invited_user)
        render(json: { success: false })
        return
      end

      trip_invite = Travels::TripInvite.create(
        inviting_user: current_user, invited_user: invited_user, trip: @trip
      )
      render json: { success: trip_invite.persisted? }
    end

    def destroy
      if params[:trip_invite_id].present?
        destroy_invite
      else
        destroy_participant
      end
      head 200
    end

    private

    def destroy_invite
      trip_invite = @trip.pending_invites.where(
        invited_user: params[:trip_invite_id]
      ).first
      head(404) && return if trip_invite.blank?
      trip_invite.destroy
    end

    def destroy_participant
      user = @trip.users.find(params[:user_id])
      @trip.users.delete(user)
      @trip.save
    end

    def find_trip
      @trip = ::Trips.by_id(params[:id])
    end

    def authorize
      head(403) && return unless @trip.include_user(current_user)
    end

    def authorize_destroy
      head(403) && return if !author? || removing_author?
    end

    def author?
      @trip.author_user == current_user
    end

    def removing_author?
      params[:user_id].to_s == @trip.author_user.id.to_s
    end
  end
end
