module Travels
  class Day

    include Mongoid::Document

    embedded_in :plan, class_name: 'Travels::Plan'

    field :date_when, type: Date
    field :comment, type: String

  end
end