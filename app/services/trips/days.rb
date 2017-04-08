# frozen_string_literal: true

module Trips
  module Days
    # UPDATE ACTIONS
    def self.update_on_dates_change(trip)
      trip.days ||= []
      # ensure order
      update_dates(trip)
      # delete not needed days
      remove_days(trip)
      # push new days
      add_days(trip)
    end

    # INTERNAL ACTIONS
    def self.update_dates(trip)
      trip.ensure_days_order
    end

    def self.add_days(trip)
      previous_day = trip.days.last
      (trip.days_count - trip.days.length).times do
        previous_day = trip.days.create(next_day(previous_day, trip))
      end
    end

    def self.next_day(day, trip)
      if day.present?
        {
          index: day.index + 1,
          date_when: ((day.date_when + 1.day) if day.date_when.present?)
        }
      else
        { index: 0, date_when: trip.start_date }
      end
    end

    def self.remove_days(trip)
      (trip.days[trip.days_count..-1] || []).each(&:destroy)
    end
  end
end
