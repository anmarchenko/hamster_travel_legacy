module Travels
  class Hotel
    include Mongoid::Document

    field :name
    field :price, type: Integer

    embeds_many :links, class_name: 'ExternalLink', inverse_of: nil

    def as_json(*args)
      {
          id: id.to_s,
          name: name,
          price: price,
          links: links
      }
    end

  end
end