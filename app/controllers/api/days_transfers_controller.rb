# frozen_string_literal: true

module Api
  class DaysTransfersController < ApplicationController
    before_action :find_trip
    before_action :api_authorize_readonly!

    FETCHED_FIELDS = %i[transfers hotel places].freeze

    def index
      render json: {
        days: Views::DayView.index_json(
          Trips::Days.list(@trip, FETCHED_FIELDS),
          FETCHED_FIELDS,
          current_user
        )
      }
    end

    private

    def find_trip
      @trip = Travels::Trip.where(id: params[:trip_id]).first
      head(404) && return if @trip.blank?
    end
  end
end
