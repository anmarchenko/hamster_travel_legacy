class Updaters::DayExpenses < Updaters::Entity

  attr_accessor :day, :expenses

  def initialize day, expenses
    self.day = day
    self.expenses = expenses
  end

  def process
    process_nested(day.expenses, expenses || [])
    day.save
  end

end