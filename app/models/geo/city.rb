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
      [
        translated_name(args[:locale]),
        (region_text(args[:locale]) if args[:with_region]),
        (country_text(args[:locale]) if args[:with_country])
      ].compact.join(', ')
    end

    def region_text(locale)
      reg = region&.translated_name locale
      reg if reg != translated_name(locale)
    end

    def country_text(locale)
      country&.translated_name locale
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
  end
end
