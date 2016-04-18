class Updaters::Activities < Updaters::Entity

  attr_accessor :day, :activities

  def initialize day, activities
    self.day = day
    self.activities = activities
  end

  def process
    self.activities = reject_empty(self.activities || [])
    process_ordered(self.activities)
    process_nested(day.activities, self.activities)
    day.save
  end

  def reject_empty acts
    acts.delete_if {|act| act['name'].blank?} || []
  end

end