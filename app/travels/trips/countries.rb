# frozen_string_literal: true

module Trips
  module Countries
    def self.visited_countries(trip)
      trip.countries.uniq
    end
  end
end
