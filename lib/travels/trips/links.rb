# frozen_string_literal: true

module Trips
  module Links
    def self.list_day(day)
      day.links
    end

    def self.list_hotel(hotel)
      hotel.links.present? ? hotel.links : [ExternalLink.new]
    end

    def self.list_transfer(transfer)
      transfer.links.present? ? transfer.links : [ExternalLink.new]
    end
  end
end
