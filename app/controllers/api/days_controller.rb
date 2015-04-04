module Api

  class DaysController < ApplicationController

    before_filter :find_trip
    before_filter :find_day, only: [:show]
    before_filter :authenticate_user!, only: [:create, :update]
    before_filter :authorize, only: [:create, :update]

    respond_to :json

    def index
      respond_with @trip.days
    end

    def create
      params.permit!
      Travels::Updaters::TripUpdater.new(@trip, params[:days]).process_days
      head 200
    end

    def show
      respond_with @day
    end

    def update
      params.permit!
      Travels::Updaters::TripUpdater.new(@trip, { '0' => day_params }).process_days
      head 200
    end

    private

    def find_trip
      @trip = Travels::Trip.where(id: params[:trip_id]).first
      head 404 and return if @trip.blank?
    end

    def find_day
      @day = @trip.days.where(id: params[:id]).first
      head 404 and return if @day.blank?
    end

    def authorize
      head 403 and return if !@trip.include_user(current_user)
    end

    def day_params
      params.require(:days).permit!
    end

  end

end