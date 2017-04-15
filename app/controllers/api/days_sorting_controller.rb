# frozen_string_literal: true

module Api
  class DaysSortingController < ApplicationController
    before_action :find_trip
    before_action :authenticate_user!
    before_action :authorize

    respond_to :json

    def index
      respond_with Views::DayView.reordering_index(@trip.days)
    end

    def create
      res = Trips::Days::Ordering.reorder(
        @trip,
        params[:day_ids],
        params[:fields]
      )
      render json: { result: res.first }
    end

    private

    def find_trip
      @trip = Travels::Trip.where(id: params[:trip_id]).first
      head(404) && return if @trip.blank?
    end

    def authorize
      head(403) && return unless @trip.include_user(current_user)
    end
  end
end
