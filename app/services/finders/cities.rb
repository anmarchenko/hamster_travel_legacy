# frozen_string_literal: true
module Finders
  class Cities
    EMPTY_TERM = '[$empty$]'

    def self.search(term, user = nil, trip_id = nil)
      return empty_suggestions(user, trip_id) if term == EMPTY_TERM && user
      Rails.cache.fetch(
        "cities_by_#{term}_#{I18n.locale}_2016_01_07", expires_in: 1.year.to_i
      ) do
        query = Geo::City.find_by_term(term).page(1)
        json_result(query)
      end
    end

    def self.empty_suggestions(user, trip_id)
      trip = user.trips.where(id: trip_id).first
      query = [user&.home_town, trip&.visited_cities].flatten.compact.uniq
      json_result(query)
    end

    def self.json_result(query)
      query.collect(&:json_hash_with_regions)
    end
  end
end
