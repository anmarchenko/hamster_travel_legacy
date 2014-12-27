module Api
  class CitiesController < ApplicationController
    respond_to :json

    def index
      term = params[:term] || ''
      respond_with [] and return if term.blank? || term.length < 3
      # cache here by term
      res = Rails.cache.fetch("cities_by_#{term}", :expires_in => 1.year.to_i) do
        query = Geo::City.find_by_term(term).page(1)
        query.collect { |city| {name: city.translated_name, text: city.translated_text, code: city.geonames_code} }
      end
      respond_with res
    end
  end
end