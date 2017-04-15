# frozen_string_literal: true

module Api
  class DaysActivitiesController < Api::BaseController
    before_action :find_trip
    before_action :api_authorize_readonly!

    FETCHED_FIELDS = %i[expenses activities links places].freeze

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
      @trip = ::Trips.by_id(params[:trip_id])
    end
  end
end
