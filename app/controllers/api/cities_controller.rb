# frozen_string_literal: true

module Api
  class CitiesController < Api::BaseController
    def index
      term = params[:term] || ''
      render(json: []) && return if term.blank? || term.length < 3
      render json: Views::CityView.index_json_with_regions(
        Trips::Places.cities_typeahead(
          term, current_user, params[:trip_id]
        )
      )
    end
  end
end
