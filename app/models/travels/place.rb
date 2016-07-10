# == Schema Information
#
# Table name: places
#
#  id      :integer          not null, primary key
#  day_id  :integer
#  city_id :integer
#

module Travels
  class Place < ApplicationRecord

    belongs_to :day, class_name: 'Travels::Day'
    belongs_to :city, class_name: 'Geo::City', required: false

    default_scope { includes(:city) }

    def city_text
      self.city.try(:translated_name, I18n.locale)
    end

    def country_code
      self.city.try(:country_code)
    end

    def is_empty?
      [:city_id, :city_text].each do |field|
        return false unless self.send(field).blank?
      end
      return true
    end

    def serializable_hash(_args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['city_text'] = self.city_text
      json['flag_image'] = ApplicationController.helpers.flag(self.country_code)
      json
    end

  end
end
