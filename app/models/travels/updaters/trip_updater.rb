module Travels
  module Updaters

    class TripUpdater
      attr_accessor :trip, :params

      def initialize(trip, params)
        self.trip = trip
        self.params = params
      end

      def process_days
        params.each do |index, day_hash|
          day = trip.days.where(id: day_hash[:id]).first
          next if day.blank?
          process_places(day, day_hash[:places])
        end
      end

      private

      def process_places(day, places_params)
        # destroy
        to_delete = []
        day.places.each do |place|
          to_delete << place.id if places_params.select{|v| v[:id] == place.id.to_s}.count == 0
        end
        day.places.where(:id.in => to_delete).destroy

        places_params.each do |place_hash|
          place = day.places.where(id: place_hash[:id]).first
          if place.blank?
            day.places.create(city_code: place_hash[:city_code], city_text: place_hash[:city_text])
          else
            place.update_attributes(city_code: place_hash[:city_code], city_text: place_hash[:city_text])
          end
        end
      end

    end

  end
end