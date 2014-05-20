module Travels
  class Hotel
    include Mongoid::Document

    embedded_in :day, class_name: 'Travels::Day'

    field :name
    field :price, type: Integer
    field :comment

    has_and_belongs_to_many :links, class_name: 'ExternalLink', inverse_of: nil

    def as_json(*args)
      {
          id: id.to_s,
          name: name,
          price: price,
          comment: comment,
          links: links
      }
    end

  end
end