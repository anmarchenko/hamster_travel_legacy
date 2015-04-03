module Travels

  class Expense < ActiveRecord::Base
    include Concerns::Copyable

    belongs_to :expendable, polymorphic: true

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