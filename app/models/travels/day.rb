module Travels
  class Day

    include Mongoid::Document
    include Mongoid::Timestamps

    embedded_in :plan, class_name: 'Travels::Plan'

    field :date, type: Date
    field :comment, type: String

    validates :date, presence: true

  end
end