# frozen_string_literal: true

module Api
  class CountriesController < Api::BaseController
    respond_to :json

    before_action :find_trip
    before_action :api_authorize_readonly!, only: [:show]

    def show
      render json: {
        countries: @trip.visited_countries_codes.map do |country_code|
          Views::FlagView.flag(country_code, 32)
        end
      }
    end

    private

    def find_trip
      @trip = ::Trips.by_id(params[:id])
    end
  end
end
