# frozen_string_literal: true

module Api
  class ActivitiesController < Api::BaseController
    before_action :find_trip
    before_action :find_day
    before_action :authenticate_user!, only: [:create]
    before_action :authorize, only: [:create]
    before_action :api_authorize_readonly!, only: [:index]

    def index
      render json: Views::DayView.show_json(
        @day,
        %i[expenses activities links places],
        current_user
      )
    end

    def create
      Trips::Days.update_day(@trip, @day, day_params)
      render json: { status: 0 }
    end

    private

    def day_params
      params.require(:day).permit(
        :comment,
        activities: %i[
          id name comment link_url amount_cents amount_currency
          rating address working_hours
        ],
        links: %i[id description url],
        expenses: %i[id name amount_cents amount_currency],
        places: %i[id city_id]
      )
    end

    def authorize
      head(403) && return unless @trip.include_user(current_user)
    end

    def find_trip
      @trip = ::Trips.by_id(params[:trip_id])
    end

    def find_day
      @day = @trip.days.find(params[:day_id])
    end
  end
end
