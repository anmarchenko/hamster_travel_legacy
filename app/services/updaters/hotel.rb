# frozen_string_literal: true
module Updaters
  class Hotel < Updaters::Entity
    attr_accessor :day, :hotel

    def initialize(day, hotel)
      self.day = day
      self.hotel = hotel || {}
    end

    def process
      process_nested(day.hotel.links, hotel.delete(:links) || [])
      process_amount(hotel)
      day.hotel.update_attributes(hotel)
      day.save
    end
  end
end
