module Travels
  class Day

    include Mongoid::Document

    embedded_in :trip, class_name: 'Travels::Trip'

    field :date_when, type: Date
    field :comment, type: String

    embeds_many :places, class_name: 'Travels::Place'

    before_save :init_places

    def init_places
      self.places = [Travels::Place.new] if self.places.blank?
    end

    def as_json(*args)
      {
          id: id.to_s,
          date: date_when.to_s,
          places: places
      }
    end

  end
end