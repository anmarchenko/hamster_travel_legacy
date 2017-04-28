# frozen_string_literal: true

module Views
  module Decorators
    module DaysNestedFields
      FIELD_NAMES = %w[activities expenses hotel transfers links places].freeze
      def self.decorate(
        target_json, day, nested_objects = [], current_user = nil
      )
        nested_objects.reduce(target_json) do |json, field_name|
          json.merge(
            field_name.to_s => nested_json(day, field_name.to_s, current_user)
          )
        end
      end

      def self.nested_json(day, field_name, current_user = nil)
        if FIELD_NAMES.include?(field_name)
          return send(field_name, day, current_user)
        end
        raise "Unknown day nested field name: #{field_name}"
      end

      def self.activities(day, current_user)
        Views::ActivityView.index_json(
          Trips::Activities.list(day),
          current_user
        )
      end

      def self.expenses(day, current_user)
        Views::ExpenseView.index_json(
          Trips::Expenses.list(day),
          current_user
        )
      end

      def self.hotel(day, current_user)
        Views::HotelView.show_json(
          Trips::Hotels.by_day(day),
          current_user
        )
      end

      def self.transfers(day, current_user)
        Views::TransferView.index_json(
          Trips::Transfers.list(day),
          current_user
        )
      end

      def self.links(day, _current_user = nil)
        Views::LinkView.index_json(
          Trips::Links.list_day(day)
        )
      end

      def self.places(day, _current_user = nil)
        Views::PlaceView.index_json(
          Trips::Places.list(day)
        )
      end
    end
  end
end
