# frozen_string_literal: true
# == Schema Information
#
# Table name: cities
#
#  id                         :integer          not null, primary key
#  geonames_code              :string
#  geonames_modification_date :date
#  latitude                   :float
#  longitude                  :float
#  population                 :integer
#  country_code               :string
#  region_code                :string
#  district_code              :string
#  adm3_code                  :string
#  adm4_code                  :string
#  adm5_code                  :string
#  timezone                   :string
#  status                     :string
#

module Geo
  class City < ApplicationRecord
    include Concerns::Geographical

    translates :name, fallbacks_for_empty_translations: true

    module Statuses
      CAPITAL = 'capital'
      REGION_CENTER = 'region_center'
      DISTRICT_CENTER = 'district_center'
      ADM3_CENTER = 'adm3_center'
      ADM4_CENTER = 'adm4_center'
      ADM5_CENTER = 'adm5_center'
    end

    def translated_text(
        args = { with_region: true, with_country: true, locale: I18n.locale }
    )
      text = translated_name(args[:locale])
      if args[:with_region]
        reg = region.try(:translated_name, args[:locale])
        text += ", #{reg}" unless reg.blank? || (reg == text)
      end
      if args[:with_country]
        c = country.try(:translated_name, args[:locale])
        text += ", #{c}" unless c.blank?
      end
      text
    end

    def capital?
      status == Statuses::CAPITAL
    end

    def region_center?
      status == Statuses::REGION_CENTER
    end

    def district_center?
      status == Statuses::DISTRICT_CENTER
    end

    def adm3_center?
      status == Statuses::ADM3_CENTER
    end

    def adm4_center?
      status == Statuses::ADM4_CENTER
    end

    def adm5_center?
      status == Statuses::ADM5_CENTER
    end

    def self.find_by_term(term)
      term = Regexp.escape(term)
      all.with_translations.where(
        '"city_translations"."name" ILIKE ?', "#{term}%"
      ).order(population: :desc)
    end

    def json_hash
      {
        id: id,
        name: translated_name(I18n.locale),
        code: id,
        flag_image: ApplicationController.helpers.flag(country_code),
        latitude: latitude,
        longitude: longitude
      }
    end

    def json_hash_with_regions
      json_hash.merge(
        text: translated_text(
          with_region: true,
          with_country: true,
          locale: I18n.locale
        )
      )
    end
  end
end
