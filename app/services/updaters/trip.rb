# frozen_string_literal: true
module Updaters
  class Trip
    attr_accessor :trip

    def initialize(trip)
      self.trip = trip
    end

    def update(params_trip)
      previous_days_count = trip.days_count
      trip.update_attributes(params_trip)
      return unless trip.errors.blank?
      current_days_count = trip.days_count
      dates_changed = current_days_count != previous_days_count
      trip.update_plan!
      trip.update_caterings! if dates_changed
    end

    def update_budget_for(budget_for)
      trip.update_attributes(budget_for: budget_for)
    end

    def update_report(report)
      trip.update_attributes(comment: report)
    end
  end
end
