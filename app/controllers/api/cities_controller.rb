module Api
  class CitiesController < ApplicationController
    respond_to :json

    def index
      term = params[:term] || ''
      respond_with [] and return if term.blank? || term.length < 3
      query = Geo::City.find_by_term(term).page(params[:page] || 1)
      respond_with query.collect { |city| {name: city.translated_name, text: city.translated_text, code: city.geonames_code} }
    end
  end
end