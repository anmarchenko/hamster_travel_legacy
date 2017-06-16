# frozen_string_literal: true

# == Schema Information
#
# Table name: countries
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
#  iso_code                   :string
#  iso3_code                  :string
#  iso_numeric_code           :string
#  area                       :integer
#  currency_code              :string
#  currency_text              :string
#  languages                  :text             default([]), is an Array
#  continent                  :string
#

module Geo
  class Country < ApplicationRecord
    include Concerns::Geographical

    translates :name, fallbacks_for_empty_translations: true

    has_many :regions, foreign_key: :country_code,
                       primary_key: :country_code, class_name: 'Geo::Region'

    has_many :cities, foreign_key: :country_code,
                      primary_key: :country_code, class_name: 'Geo::City'

    def iso_info
      ISO3166::Country.find_country_by_alpha2(iso_code)
    end

    def visited_country_json
      {
        name: name(I18n.locale),
        iso3_code: iso3_code,
        flag_image: Views::FlagView.flag_with_title(self, 32)
      }
    end

    def self.find_by_term(term)
      term = Regexp.escape(term)
      all.with_translations.where(
        '"country_translations"."name" ILIKE ?', "#{term}%"
      ).order(population: :desc)
    end

    def self.method_missing(m, *args, &block)
      country_code = m.upcase
      res = find_by_country_code(country_code)
      res ? res : super
    end

    def self.respond_to_missing?(method_name, include_private = false)
      super
    end

    def self.find_by_country_code(code)
      Geo::Country.where(
        'iso_code = ? or iso3_code = ?', code, code
      ).first
    end
  end
end
