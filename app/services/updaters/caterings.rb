# frozen_string_literal: true
class Updaters::Caterings < Updaters::Entity
  attr_accessor :trip, :caterings

  def initialize(trip, caterings)
    self.trip = trip
    self.caterings = caterings
  end

  def process
    process_ordered(caterings)
    process_nested(trip.caterings, caterings)
    trip.save
  end
end
