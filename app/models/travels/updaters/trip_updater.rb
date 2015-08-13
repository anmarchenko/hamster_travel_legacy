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
        unless trip.blank?
          new_trip.days.each_with_index do |day, index|
            original_day = (trip.days || [])[index]
            next if original_day.blank?
            date_when = day.date_when
            day.copy(original_day, true)
            day.date_when = date_when
            day.save
          end
        end
        new_trip
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
          process_nested(day.transfers, day_hash[:transfers] || [])

          activities_params = prepare_activities_params(day_hash[:activities] || [])
          process_ordered(activities_params)
          process_nested(day.activities, activities_params)

          process_nested(day.expenses, day_hash[:expenses] || [])

          day.save
        end
      end

      def process_caterings
        caterings = []

        params.each do |_, catering_hash|
          caterings << catering_hash
        end

        process_ordered(caterings)
        process_nested(trip.caterings, caterings, [:expenses])
      end

      def process_trip
        trip.update_attributes(comment: params[:comment], budget_for: params[:budget_for])
        trip
      end

      private

      def prepare_activities_params act_params
        act_params.delete_if { |hash| hash[:name].blank? } || []
      end

      # TODO permit only some params - possible security problem
      def process_nested(collection, params, recursive = [])
        to_delete = []
        collection.each do |item|
          to_delete << item.id if params.select { |v| v[:id] == item.id.to_s }.count == 0
        end
        collection.where(:id => to_delete).destroy_all
        params.each do |item_hash|
          item_id = (item_hash.delete(:id).to_i % 2147483647) rescue nil
          process_amount(item_hash)
          item = collection.where(id: item_id).first unless item_id.nil?
          # TODO remove - only for client side
          item_hash.delete(:isCollapsed)

          recursive_hash = process_recursive(recursive, item_hash)
          if item.blank?
            item = collection.create(item_hash)
          else
            item.update_attributes(item_hash)
          end

          run_recursive(item, recursive_hash)
        end
      end

      def run_recursive item, rec_hash
        rec_hash.each do |relation, data|
          process_nested(item.send(relation), data || [])
        end
      end

      def process_recursive recursive, item_hash
        res = {}
        recursive.each do |relation|
          res[relation] = item_hash.delete(relation)
        end
        res
      end

      def process_ordered(params)
        params.each_with_index do |item_hash, index|
          item_hash['order_index'] = index
        end
      end

      def process_amount(hash)
        hash['amount_cents'] = hash['amount_cents'].to_i * 100 unless hash['amount_cents'].nil?
        hash.delete('amount_currency_text')
      end

    end

  end
end