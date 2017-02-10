# frozen_string_literal: true
class Updaters::DayLinks < Updaters::Entity
  attr_accessor :day, :links

  def initialize(day, links)
    self.day = day
    self.links = links
  end

  def process
    process_nested(day.links, links || [])
    day.save
  end
end
