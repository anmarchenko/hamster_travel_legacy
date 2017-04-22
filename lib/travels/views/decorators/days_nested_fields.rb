# frozen_string_literal: true

module Views
  module Decorators
    module DaysNestedFields
      FIELD_NAMES = %w[activities expenses hotel transfers links places].freeze
      def self.decorate(target_json, day, nested_objects = [])
        nested_objects.reduce(target_json) do |json, field_name|
          json.merge(
            field_name.to_s => nested_json(day, field_name.to_s)
          )
        end
      end

      def self.nested_json(day, field_name)
        return send(field_name, day) if FIELD_NAMES.include?(field_name)
        raise "Unknown day nested field name: #{field_name}"
      end

      def self.activities(day)
        Views::ActivityView.index_json(
          Trips::Activities.list(day)
        )
      end

      def self.expenses(day)
        Views::ExpenseView.index_json(
          Trips::Expenses.list(day)
        )
      end

      def self.hotel(day)
        Views::HotelView.show_json(
          Trips::Hotels.by_day(day)
        )
      end

      def self.transfers(day)
        Views::TransferView.index_json(
          Trips::Transfers.list(day)
        )
      end

      def self.links(day)
        Views::LinkView.index_json(
          Trips::Links.list_day(day)
        )
      end

      def self.places(day)
        Views::PlaceView.index_json(
          Trips::Places.list(day)
        )
      end
    end
  end
end
