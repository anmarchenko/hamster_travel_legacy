module Api

  class DaysController < ApplicationController

    before_filter :find_trip
    before_filter :authenticate_user!
    before_filter :authorize

    respond_to :json

    def index
      respond_with @trip.days
    end

    def create
      Travels::Updaters::TripUpdater.new(@trip, params[:days]).process_days
      head 200
    end

    private

    def find_trip
      @trip = Travels::Trip.where(id: params[:trip_id]).first
      head 404 and return if @trip.blank?
    end

    def authorize
      head 403 and return if !@trip.include_user(current_user)
    end

  end

end