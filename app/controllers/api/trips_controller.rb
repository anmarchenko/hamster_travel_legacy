module Api
  class TripsController < ApplicationController
    def index
      term = params[:term] || ''
      render json: [] and return if term.blank?
      render json: Finders::Trips.search(term, current_user).map(&:json_typeahead)
    end
  end
end
