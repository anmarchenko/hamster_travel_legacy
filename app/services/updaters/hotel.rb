class Updaters::Hotel < Updaters::Entity
  attr_accessor :day, :hotel

  def initialize day, hotel
    self.day = day
    self.hotel = hotel
  end

  def process
    process_amount(hotel)
    day.hotel.update_attributes(name: hotel[:name], amount_cents: hotel[:amount_cents],
                                amount_currency: hotel[:amount_currency], comment: hotel[:comment])
    process_nested(day.hotel.links, hotel[:links] || [])
    day.save
  end

end
