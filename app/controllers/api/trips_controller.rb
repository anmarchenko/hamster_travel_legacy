module Api

  class TripsController < ApplicationController

    before_filter :find_trip, only: [:show, :update]
    before_filter :authenticate_user!, only: [:update]
    before_filter :authorize, only: [:update]

    respond_to :json

    def show
      respond_with @trip
    end

    def update
      respond_with @trip
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

end