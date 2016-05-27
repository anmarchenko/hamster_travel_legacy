class Finders::Cities

  EMPTY_TERM = '[$empty$]'
  def self.search term, user = nil, trip_id = nil
    return empty_suggestions(user, trip_id) if term == EMPTY_TERM && user
    Rails.cache.fetch("cities_by_#{term}_#{I18n.locale}_2016_01_07", :expires_in => 1.year.to_i) do
      query = Geo::City.find_by_term(term).page(1)
      json_result(query)
    end
  end

  def self.empty_suggestions user, trip_id
    trip = user.trips.find(trip_id) rescue nil
    query = [user.try(:home_town), trip.try(:visited_cities)].flatten.compact.uniq
    json_result(query)
  end

  def self.json_result query
    query.collect { |city| city_json(city) }
  end

  def self.city_json city
    {
        name: city.translated_name(I18n.locale),
        text: city.translated_text(with_region: true, with_country: true, locale: I18n.locale),
        code: city.id,
        flag_image: ApplicationController.helpers.flag(city.country_code)
    }
  end

end