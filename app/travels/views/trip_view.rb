# frozen_string_literal: true

module Views
  module TripView
    def self.show_json(trip)
      trip.as_json
    end

    def self.index_list_json(trips, opts = { flag_size: 16 })
      trips.map { |trip| show_list_json(trip, opts) }
    end

    def self.show_list_json(trip, opts = { flag_size: 16 })
      {
        id: trip.id,
        name: trip.name,
        start_date: trip.start_date,
        image_url: trip.image_url_or_default,
        countries: Views::FlagView.index_flags_with_titles(
          Trips::Countries.visited_countries(trip), opts[:flag_size]
        )
      }
    end

    def self.status_text(trip)
      I18n.t(Trips::StatusCodes::TYPE_TO_TEXT[trip.status_code])
    end
  end
end
