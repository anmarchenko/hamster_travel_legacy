module Travels
  class Plan
    include Mongoid::Document
    include Mongoid::Timestamps

    embedded_in :trip, class_name: 'Travels::Trip'

    field :name
    embeds_many :days, class_name: 'Travels::Day'

  end
end