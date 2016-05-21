module Travels
  module Updaters

    class TripUpdater
      attr_accessor :trip, :params, :user

      def initialize(trip, params, user = nil)
        self.trip = trip
        self.params = params
        self.user = user
      end

      def new_trip
        new_trip = Travels::Trip.new
        new_trip.copy(trip) unless trip.blank?
        new_trip
      end

      def create_trip
        new_trip = Travels::Trip.new(params)
        new_trip.author_user_id = user.id
        new_trip.users = [user]
        new_trip.save
        copy_plan(trip, new_trip) unless trip.blank?
        new_trip
      end

      def copy_plan from, to
        to.days.each_with_index do |day, index|
          original_day = (from.days || [])[index]
          next if original_day.blank?
          date_when = day.date_when
          day.copy(original_day, true)
          day.date_when = date_when
          day.save
        end

        from.caterings.each do |catering|
          to.caterings.create(catering.attributes.except('id', 'trip_id'))
        end
      end

      def process_days
        params.each do |_, day_hash|
          day = trip.days.where(id: day_hash[:id]).first
          next if day.blank?

          unless day_hash[:hotel].blank?
            hotel_hash = day_hash[:hotel]
            process_amount(hotel_hash)
            day.hotel.update_attributes(name: hotel_hash[:name], amount_cents: hotel_hash[:amount_cents],
                                        amount_currency: hotel_hash[:amount_currency], comment: hotel_hash[:comment])
            process_nested(day.hotel.links, day_hash[:hotel][:links] || [])
          end

          day.update_attributes(comment: day_hash[:comment])

          process_nested(day.places, day_hash[:places] || [])

          process_ordered(day_hash[:transfers] || [])
          process_nested(day.transfers, day_hash[:transfers] || [], ['links'])

          activities_params = prepare_activities_params(day_hash[:activities] || [])
          process_ordered(activities_params)
          process_nested(day.activities, activities_params)

          process_nested(day.expenses, day_hash[:expenses] || [])

          process_nested(day.links, day_hash[:links] || [])

          day.save
        end
      end

      def process_caterings
        caterings = []

        params.each do |_, catering_hash|
          caterings << catering_hash
        end

        process_ordered(caterings)
        process_nested(trip.caterings, caterings)
      end

      private

      def prepare_activities_params act_params
        act_params.delete_if { |hash| hash[:name].blank? } || []
      end

      # TODO permit only some params - possible security problem
      def process_nested(collection, params, nested_list = [])
        to_delete = []
        collection.each do |item|
          to_delete << item.id if params.select { |v| v[:id].to_s == item.id.to_s }.count == 0
        end
        collection.where(:id => to_delete).destroy_all
        params.each do |item_hash|
          item_id = (item_hash.delete(:id).to_i % 2147483647) rescue nil
          item = collection.where(id: item_id).first unless item_id.nil?
          # TODO remove - only for client side
          process_amount(item_hash)
          [:isCollapsed, :city_text, :city_from_text, :city_to_text, :flag_image, :amount_currency_text].each do |forbidden_attribute|
            item_hash.delete(forbidden_attribute)
          end
          nested_hash = {}
          nested_list.each do |nested_attr|
            nested_hash[nested_attr] = item_hash.delete(nested_attr)
          end

          if item.blank?
            item = collection.create(item_hash)
          else
            item.update_attributes(item_hash)
          end

          nested_hash.each do |attr, values|
            process_nested(item.send(attr), values) if values.present?
          end
        end
      end

      def process_ordered(params)
        params.each_with_index do |item_hash, index|
          item_hash['order_index'] = index
        end
      end

      def process_amount item_hash
        (item_hash['amount_cents'] = item_hash['amount_cents'].to_i rescue nil) unless item_hash['amount_cents'].nil?
      end

    end

  end
end