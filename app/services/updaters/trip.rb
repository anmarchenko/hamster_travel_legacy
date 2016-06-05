class Updaters::Trip
  attr_accessor :trip

  def initialize trip
    self.trip = trip
  end

  def update params_trip
    trip.update_attributes(params_trip)
    if trip.errors.blank?
      trip.update_plan!
      trip.update_caterings!
    end
  end

  def update_budget_for budget_for
    trip.update_attributes(budget_for: budget_for)
  end

  def update_report report
    trip.update_attributes(comment: report)
  end
end