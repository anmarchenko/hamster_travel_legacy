module Travels

  class Activity

    include Mongoid::Document
    include Concerns::Ordered

    embedded_in :day, class_name: 'Travels::Day'

    field :name
    field :price, type: Integer
    field :comment

    field :link_description
    field :link_url

    PERMITTED = %w(name price comment link_description link_url order_index id)

    def as_json(**args)
      attrs = super(args)
      attrs['id'] = id.to_s
      attrs.reject{|k, _| !PERMITTED.include?(k)}
    end

  end

end