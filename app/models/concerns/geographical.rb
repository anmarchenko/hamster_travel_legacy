# frozen_string_literal: true
require 'active_support/concern'

module Concerns
  module Geographical
    extend ActiveSupport::Concern

    def translated_name(locale = I18n.locale)
      res = nil
      Globalize.with_locale(locale) do
        res = name
      end
      if res.blank?
        # fallback
        Globalize.with_locale(:en) do
          res = name
        end
      end
      res
    end

    def country
      ::Geo::Country.where(country_code: country_code).first
    end

    def region
      ::Geo::Region.where(region_code: region_code, country_code: country_code).first
    end

    def district
      ::Geo::District.where(district_code: district_code,
                            region_code: region_code,
                            country_code: country_code).first
    end

    def adm3
      ::Geo::Adm3.where(adm3_code: adm3_code,
                        district_code: district_code,
                        region_code: region_code,
                        country_code: country_code).first
    end

    def adm4
      ::Geo::Adm4.where(adm4_code: adm4_code,
                        adm3_code: adm3_code,
                        district_code: district_code,
                        region_code: region_code,
                        country_code: country_code).first
    end

    def adm5
      ::Geo::Adm5.where(adm5_code: adm5_code,
                        adm4_code: adm4_code,
                        adm3_code: adm3_code,
                        district_code: district_code,
                        region_code: region_code,
                        country_code: country_code).first
    end

    def update_from_geonames_string(str)
      values = self.class.split_geonames_string(str)
      update_attributes(
        geonames_code: values[0].strip,
        name: values[1].strip,
        latitude: values[4].strip,
        longitude: values[5].strip,
        country_code: values[8].strip,
        region_code: values[10].strip,
        district_code: values[11].strip,
        adm3_code: values[12].strip,
        adm4_code: values[13].strip,
        population: values[14].strip,
        timezone: values[17].strip,
        geonames_modification_date: values[18].strip
      )
    end

    module ClassMethods
      def split_geonames_string(str)
        str.split(/\t/)
      end

      def by_geonames_code(code)
        where(geonames_code: code).first
      end
    end
  end
end
