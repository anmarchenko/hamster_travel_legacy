# frozen_string_literal: true

module Api
  class DaysTransfersController < Api::BaseController
    before_action :find_trip
    before_action :api_authorize_readonly!

    def index
      nested_fields = %i[transfers hotel places].freeze
      render json: {
        days: Views::DayView.index_json(
          Trips::Days.list(@trip, nested_fields),
          nested_fields,
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
