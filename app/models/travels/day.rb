module Travels
  class Day

    include Mongoid::Document

    embedded_in :trip, class_name: 'Travels::Trip'

    field :date_when, type: Date

    embeds_many :places, class_name: 'Travels::Place'
    embeds_many :transfers, class_name: 'Travels::Transfer'
    embeds_one :hotel, class_name: 'Travels::Hotel'
    embeds_many :activities, class_name: 'Travels::Activity'

    field :comment, type: String
    field :add_price, type: Integer

    before_save :init

    def init
      self.places = [Travels::Place.new] if self.places.blank?
      self.hotel = Travels::Hotel.new if self.hotel.blank?
    end

    def as_json(*args)
      {
          id: id.to_s,
          date: (I18n.l(date_when, format: '%d.%m.%Y %A') unless date_when.blank?),
          places: places,
          transfers: transfers,
          activities: activities,
          comment: comment,
          add_price: add_price,
          hotel: hotel
      }
    end

  end
end