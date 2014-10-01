module Travels

  class Expense

    include Mongoid::Document

    embedded_in :expendable, polymorphic: true

    field :price, type: Integer
    field :name

    def is_empty?
      return price.blank? && name.blank?
    end

    def as_json(*args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['price'] = price
      json['name'] = name
      json
    end

  end

end