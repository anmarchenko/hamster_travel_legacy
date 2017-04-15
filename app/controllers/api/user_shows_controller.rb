# frozen_string_literal: true

module Api
  class UserShowsController < Api::BaseController
    before_action :find_trip
    before_action :authenticate_user!
    before_action :authorize

    def show
      render json: Presence.new.present_users(params[:id], current_user.id)
    end

    def find_trip
      @trip = ::Trips.by_id(params[:id])
    end

    def authorize
      head(403) && return unless @trip.include_user(current_user)
    end
  end
end
