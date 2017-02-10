# frozen_string_literal: true
class Updaters::DayPlaces < Updaters::Entity
  attr_accessor :day, :places

  def initialize(day, places)
    self.day = day
    self.places = places
  end

  def process
    process_nested(day.places, places || [])
    day.save
    day.trip.regenerate_countries_search_index!
  end
end
