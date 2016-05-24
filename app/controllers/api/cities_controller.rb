module Api
  class CitiesController < ApplicationController
    def index
      term = params[:term] || ''
      render json: [] and return if term.blank? || term.length < 3

      if term == '[$empty$]'
        trip = Travels::Trip.find(params[:trip_id]) rescue nil
        query = [current_user.try(:home_town), trip.try(:visited_cities)].flatten.compact.uniq
        res = query.collect { |city| city_json(city) }
      else
        # cache here by term
        res = Rails.cache.fetch("cities_by_#{term}_#{I18n.locale}_2016_01_07", :expires_in => 1.year.to_i) do
          query = Geo::City.find_by_term(term).page(1)
          query.collect { |city| city_json(city) }
        end
      end
      render json: res
    end

    private

    def city_json city
      {
          name: city.translated_name(I18n.locale),
          text: city.translated_text(with_region: true, with_country: true, locale: I18n.locale),
          code: city.id,
          flag_image: ApplicationController.helpers.flag(city.country_code)
      }
    end
  end
end