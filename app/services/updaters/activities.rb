# frozen_string_literal: true

module Updaters
  class Activities < Updaters::Entity
    attr_accessor :day, :activities

    def initialize(day, activities)
      self.day = day
      self.activities = activities
    end

    def process
      self.activities = reject_empty(activities || [])
      process_ordered(activities)
      process_nested(day.activities, activities)
      day.save
    end

    def reject_empty(acts)
      acts.delete_if { |act| act['name'].blank? } || []
    end
  end
end
