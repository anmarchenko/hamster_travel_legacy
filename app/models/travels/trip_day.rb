module Travels
  class TripDay

    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :trip, class_name: 'Travels::Trip'

    field :day, type: Date
    field :comment, type: String

    validates :day, presence: true

  end
end