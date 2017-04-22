# frozen_string_literal: true

module Views
  module CityView
    def self.index_json(cities)
      cities.map { |city| show_json(city) }
    end

    def self.index_json_with_regions(cities)
      cities.map { |city| show_json_with_regions(city) }
    end

    def self.show_json(city)
      {
        id: city.id,
        name: city.translated_name(I18n.locale),
        code: city.id,
        flag_image: Views::FlagView.flag(city.country_code),
        latitude: city.latitude,
        longitude: city.longitude
      }
    end

    def self.show_json_with_regions(city)
      show_json(city).merge(
        text: city.translated_text(
          with_region: true,
          with_country: true,
          locale: I18n.locale
        )
      )
    end
  end
end
