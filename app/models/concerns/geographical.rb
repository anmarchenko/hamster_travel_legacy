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
      ::Geo::Region.where(
        region_code: region_code, country_code: country_code
      ).first
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
