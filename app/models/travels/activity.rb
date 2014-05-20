module Travels

  class Activity

    include Mongoid::Document

    embedded_in :day, class_name: 'Travels::Day'

    field :name
    field :price
    field :comment

    field :link_description
    field :link_url



    def as_json(*args)
      {
          id: id.to_s,
          name: name,
          price: price,
          comment: comment,
          link_description: link_description,
          link_url: link_url
      }
    end

  end

end