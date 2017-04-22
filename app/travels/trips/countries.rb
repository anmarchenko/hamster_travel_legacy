# frozen_string_literal: true

module Trips
  module Countries
    def self.visited_countries(trip)
      Geo::Country.where(country_code: trip.visited_countries_codes)
                  .with_translations
    end
  end
end
