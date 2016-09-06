module Api
  class TripsController < ApplicationController
    def index
      term = params[:term] || ''
      render json: [] and return if term.blank?
      render json: Finders::Trips.search(term, current_user).includes(:cities).map(&:short_json)
    end
  end
end
