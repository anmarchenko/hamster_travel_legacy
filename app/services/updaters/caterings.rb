class Updaters::Caterings < Updaters::Entity

  attr_accessor :trip, :caterings

  def initialize trip, caterings
    self.trip = trip
    self.caterings = caterings
  end

  def process
    process_ordered(self.caterings)
    process_nested(trip.caterings, self.caterings)
    trip.save
  end

end