module Travels
  module Updaters

    class TripUpdater
      attr_accessor :trip, :params

      def initialize(trip, params)
        self.trip = trip
        self.params = params
      end

      def process_days
        params.each do |_, day_hash|
          day = trip.days.where(id: day_hash[:id]).first
          next if day.blank?
          unless day_hash[:hotel].blank?
            hotel_hash = day_hash[:hotel]
            day.hotel.update_attributes(name: hotel_hash[:name], price: hotel_hash[:price],
              comment: hotel_hash[:comment])
            # links
            process_nested(day.hotel.links, day_hash[:hotel][:links] || [])
          end
          day.update_attributes(comment: day_hash[:comment], add_price: day_hash[:add_price])
          process_nested(day.places, day_hash[:places] || [])
          process_nested(day.transfers, day_hash[:transfers] || [])
          process_ordered(day_hash[:activities] || [])
          process_nested(day.activities, day_hash[:activities] || [])
          day.save
        end
      end

      private

      # TODO permit only some params
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

      def process_ordered(params)
        params.each_with_index do |item_hash, index|
          item_hash['order_index'] = index
        end
      end

    end

  end
end