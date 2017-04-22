# frozen_string_literal: true

module Trips
  module Caterings
    extend Common::EntityUpdater

    # READ ACTIONS
    def self.list(trip)
      if trip.caterings.blank?
        defaults(trip)
      else
        trip.caterings
      end
    end

    # UPDATE ACTIONS
    def self.save(trip, caterings_params)
      save_nested(
        trip.caterings,
        order_params(caterings_params)
      )
      trip.save
      Budgets.on_budget_change(trip)
    end

    # EVENTS
    def self.on_trip_update(trip)
      return if trip.caterings.blank? || trip.caterings.count > 1
      catering = trip.caterings.first
      catering.update_attributes(days_count: trip.days_count)
    end

    # INTERNAL ACTIONS
    def self.defaults(trip)
      [
        Travels::Catering.new(
          id: Time.now.to_i,
          persons_count: trip.budget_for,
          days_count: trip.days_count,
          amount_currency: trip.currency,
          name: "#{trip.name} (#{I18n.t('trips.show.catering')})"
        )
      ]
    end
  end
end
