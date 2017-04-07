# frozen_string_literal: true

module Trips
  # CREATE ACTIONS

  def self.new_trip(user, original_id = nil)
    return Travels::Trip.new if original_id.nil?
    original = Travels::Trip.find(original_id)
    return Travels::Trip.new unless original.can_be_seen_by?(user)
    Trips::Duplicator.duplicate(original)
  end

  def self.create_trip(params, user, original_id = nil)
    trip = new_trip(user, original_id)
    trip.assign_attributes(
      params.merge(author_user_id: user.id, users: [user])
    )
    trip.save
    trip
  end

  # UPDATE ACTIONS
  def self.update(trip, params_trip)
    previous_days_count = trip.days_count

    trip.update_attributes(params_trip)
    return trip unless trip.errors.blank?

    current_days_count = trip.days_count
    dates_changed = current_days_count != previous_days_count

    # TODO: move out
    trip.update_plan!
    trip.update_caterings! if dates_changed
    trip
  end

  def self.nullify_dates(trip)
    if trip.dates_unknown
      trip.start_date = nil
      trip.end_date = nil
    else
      trip.planned_days_count = nil
    end
  end

  def self.update_budget_for(trip, budget_for)
    trip.update_attributes(budget_for: budget_for)
  end

  def self.update_report(trip, report)
    trip.update_attributes(comment: report)
  end
end
