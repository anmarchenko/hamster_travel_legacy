module Travels
  class TripDay

    include Mongoid::Document
    include Mongoid::Timestamps

    embedded_in :trip, class_name: 'Travels::Trip'

    field :day, type: Date

    field :cities, type: Array
    field :transfers, type: Array
    field :sites, type: Array
    field :hotels, type: Array

    field :comment, type: String

    validates :day, presence: true

  end
end