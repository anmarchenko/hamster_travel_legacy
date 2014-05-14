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
          process_nested(day.places, day_hash[:places] || [])
          process_nested(day.transfers, day_hash[:transfers] || [])
        end
      end

      private

      def process_nested(collection, params)
        to_delete = []
        collection.each do |item|
          to_delete << item.id if params.select{|v| v[:id] == item.id.to_s}.count == 0
        end
        collection.where(:id.in => to_delete).destroy
        params.each do |item_hash|
          item = collection.where(id: item_hash.delete(:id)).first
          if item.blank?
            collection.create(item_hash)
          else
            item.update_attributes(item_hash)
          end
        end

      end

    end

  end
end