# == Schema Information
#
# Table name: places
#
#  id        :integer          not null, primary key
#  city_code :string
#  city_text :string
#  mongo_id  :string
#  day_id    :integer
#

module Travels
  class Place < ActiveRecord::Base

    include Concerns::Copyable

    belongs_to :day, class_name: 'Travels::Day'
    belongs_to :city, class_name: 'Geo::City', required: false

    default_scope { includes(:city) }

    def city_text
      self.city.try(:translated_name, I18n.locale)
    end

    def is_empty?
      [:city_id, :city_text].each do |field|
        return false unless self.send(field).blank?
      end
      return true
    end

    def as_json(*args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json
    end

  end
end
