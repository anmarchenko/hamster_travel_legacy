module Api

  class TripsController < ApplicationController

    before_action :find_trip, only: [:show, :update]
    before_action :authenticate_user!, only: [:update]
    before_action :authorize, only: [:update]

    respond_to :json

    def show
      respond_with @trip
    end

    def update
      Travels::Updaters::TripUpdater.new(@trip, params[:trip]).process_trip
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