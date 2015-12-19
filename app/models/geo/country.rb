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
#  mongo_id                   :string
#

module Geo
  class Country < ActiveRecord::Base

    include Concerns::Geographical

    translates :name, :fallbacks_for_empty_translations => true

    def load_additional_info(str)
      values = Geo::Country.split_geonames_string(str)
      update_attributes(
          iso_code: values[0].strip,
          iso3_code: values[1].strip,
          iso_numeric_code: values[2].strip,
          area: values[6].strip,
          continent: values[8].strip,
          currency_code: values[10].strip,
          currency_text: values[11].strip,
          languages: values[15].strip.split(/,/)
      )
    end

    def iso_info
      ISO3166::Country.find_country_by_alpha2(self.iso_code)
    end

    def self.find_by_term(term)
      term = Regexp.escape(term)
      self.all.with_translations.where("\"country_translations\".\"name\" ILIKE ?", "#{term}%").order(population: :desc)
    end

  end
end
