# frozen_string_literal: true
class Api::CountriesController < ApplicationController
  respond_to :json

  before_action :find_trip
  before_action :api_authorize_readonly!, only: [:show]

  def show
    render json: {
      countries: @trip.visited_countries_codes.map do |country_code|
        ApplicationController.helpers.flag(country_code, 32)
      end
    }
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    head(404) && return if @trip.blank?
  end
end
