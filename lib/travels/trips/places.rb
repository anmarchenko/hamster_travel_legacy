# frozen_string_literal: true

module Trips
  module Places
    EMPTY_TERM = '[$empty$]'

    def self.list(day)
      day.places
    end

    def self.last_place(day)
      day.places.last
    end

    def self.cities_typeahead(term, user = nil, trip_id = nil)
      return empty_suggestions(user, trip_id) if term == EMPTY_TERM && user
      Cities.search(term)
    end

    def self.empty_suggestions(user, trip_id)
      trip = user.trips.find(trip_id) if trip_id.present?
      [user&.home_town, trip&.visited_cities].flatten.compact.uniq
    end
  end
end
