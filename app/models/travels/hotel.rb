module Travels
  class Hotel
    include Mongoid::Document

    embedded_in :day, class_name: 'Travels::Day'

    field :name
    field :price, type: Integer
    field :comment

    has_and_belongs_to_many :links, class_name: 'ExternalLink', inverse_of: nil

    def as_json(*args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['links'] = links.as_json(args)
      json
    end

    def is_empty?
      [:name, :price, :comment, :links].each do |field|
        return false unless self.send(field).blank?
      end
      return true
    end

  end
end