module Api
  class CateringsController < ApplicationController

    before_filter :find_trip
    before_filter :authenticate_user!, only: [:create]
    before_filter :authorize, only: [:create]

    def index
      respond_with @trip.caterings
    end

    def create
      params.permit!
      Travels::Updaters::TripUpdater.new(@trip, params[:caterings]).process_caterings
      head 200
    end

    private

    def find_trip
      @trip = Travels::Trip.where(id: params[:trip_id]).first
      head 404 and return if @trip.blank?
    end

  end
end