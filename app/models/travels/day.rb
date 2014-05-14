module Travels
  class Day

    include Mongoid::Document

    embedded_in :trip, class_name: 'Travels::Trip'

    field :date_when, type: Date
    field :comment, type: String

    embeds_many :places, class_name: 'Travels::Place'
    embeds_many :transfers, class_name: 'Travels::Transfer'

    before_save :init_places

    def init_places
      self.places = [Travels::Place.new] if self.places.blank?
    end

    def as_json(*args)
      {
          id: id.to_s,
          date: (I18n.l(date_when, format: '%d.%m.%Y %A') unless date_when.blank?),
          places: places,
          transfers: transfers
      }
    end

  end
end