# frozen_string_literal: true

module Api
  class DaysSortingController < Api::BaseController
    before_action :find_trip
    before_action :authenticate_user!
    before_action :authorize

    respond_to :json

    def index
      respond_with Views::DayView.reordering_index(
        Trips::Days.list(
          @trip, %i[activities transfers expenses places links]
        )
      )
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
      @trip = ::Trips.by_id(params[:trip_id])
    end

    def authorize
      head(403) && return unless @trip.include_user(current_user)
    end
  end
end
