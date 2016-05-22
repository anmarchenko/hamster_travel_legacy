class Updaters::Transfers < Updaters::Entity
  attr_accessor :day, :transfers

  def initialize day, transfers
    self.day = day
    self.transfers = transfers
  end

  def process
    process_ordered(self.transfers)
    process_nested(day.transfers, self.transfers, ['links'])
    day.save
  end

end
