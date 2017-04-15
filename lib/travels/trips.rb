# frozen_string_literal: true

module Trips
  module StatusCodes
    DRAFT = '0_draft'
    PLANNED = '1_planned'
    FINISHED = '2_finished'

    ALL = [DRAFT, PLANNED, FINISHED].freeze
    OPTIONS = ALL.map { |type| ["common.#{type}", type] }
    TYPE_TO_TEXT = {
      DRAFT => "common.#{DRAFT}", PLANNED => "common.#{PLANNED}",
      FINISHED => "common.#{FINISHED}"
    }.freeze

    TYPE_TO_ICON = {
      DRAFT => 'draft', PLANNED => 'planned', FINISHED => 'finished'
    }.freeze
  end

  # READ ACTIONS
  def self.last_non_empty_day_index(trip)
    result = -1
    trip.days.each_with_index do |day, index|
      result = index unless day.empty_content?
    end
    result
  end

  def self.docx_file_name(trip)
    "#{trip.name[0, 50].gsub(/[^[[:word:]]\-]/, '_')}.docx"
  end

  # CREATE ACTIONS
  def self.new_trip(user, original_id = nil)
    return Travels::Trip.new if original_id.blank?
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

    if trip.days_count != previous_days_count
      Trips::Caterings.on_trip_update(trip)
    end

    Trips::Days.on_trip_update(trip)
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

  # EVENTS
  def self.on_places_update(trip)
    regenerate_search_index(trip)
  end

  # INTERNAL ACTIONS
  def self.regenerate_search_index(trip)
    trip.countries_search_index = trip.visited_cities.map do |city|
      country = city.country
      "#{country.translated_name(:en)} #{country.translated_name(:ru)}"
    end.join(' ')
    trip.save(validate: false)
  end
end
