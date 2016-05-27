module Api
  class CitiesController < ApplicationController
    def index
      term = params[:term] || ''
      render json: [] and return if term.blank? || term.length < 3
      render json: Finders::Cities.search(term, current_user, params[:trip_id])
    end
  end
end