module Api
  class CitiesController < ApplicationController
    respond_to :json

    def index
      term = params[:term] || ''
      respond_with [] and return if term.blank? || term.length < 3
      # cache here by term
      res = Rails.cache.fetch("cities_by_#{term}_#{I18n.locale}_2015_12_19_3", :expires_in => 1.year.to_i) do
        query = Geo::City.find_by_term(term).page(1)
        query.collect { |city| {name: city.translated_name(I18n.locale),
                                text: city.translated_text(with_region: true, with_country: true, locale: I18n.locale),
                                code: city.id} }
      end
      respond_with res
    end
  end
end