class Updaters::Day < Updaters::Entity

  attr_accessor :day, :day_hash

  def initialize day, day_hash
    self.day = day
    self.day_hash = day_hash
  end

  def process
    day.update_attributes(day_hash)
  end

end