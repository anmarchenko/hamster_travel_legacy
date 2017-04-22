# frozen_string_literal: true

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

    def city_text
      city&.translated_name(I18n.locale)
    end

    def country_code
      city&.country_code
    end

    def country
      city&.country
    end

    def empty_content?
      %i[city_id city_text].each do |field|
        return false unless send(field).blank?
      end
      true
    end
  end
end
