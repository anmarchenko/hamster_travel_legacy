require 'active_support/concern'

module Concerns
  module Geographical
    extend ActiveSupport::Concern

    included do
      field :geonames_code, type: String
      field :geonames_modification_date, type: Date

      field :name, type: String

      field :latitude, type: Float
      field :longitude, type: Float

      field :population, type: Integer

      field :country_code, type: String
      field :region_code, type: String
      field :district_code, type: String
      field :adm3_code, type: String
      field :adm4_code, type: String
      field :adm5_code, type: String

      field :timezone, type: String
    end

    def translated_name(locale = I18n.locale)
      ::Geo::GeoName.where(geonames_id: self.geonames_code, locale: locale).first.try(:name) || name
    end

    def country
      ::Geo::Country.where(country_code: self.country_code).first
    end

    def region
      ::Geo::Region.where(region_code: self.region_code, country_code: self.country_code).first
    end

    def district
      ::Geo::District.where(district_code: self.district_code,
                            region_code: self.region_code,
                            country_code: self.country_code).first
    end

    def adm3
      ::Geo::Adm3.where(adm3_code: self.adm3_code,
                        district_code: self.district_code,
                        region_code: self.region_code,
                        country_code: self.country_code).first
    end

    def adm4
      ::Geo::Adm4.where(adm4_code: self.adm4_code,
                        adm3_code: self.adm3_code,
                        district_code: self.district_code,
                        region_code: self.region_code,
                        country_code: self.country_code).first
    end

    def adm5
      ::Geo::Adm5.where(adm5_code: self.adm5_code,
                        adm4_code: self.adm4_code,
                        adm3_code: self.adm3_code,
                        district_code: self.district_code,
                        region_code: self.region_code,
                        country_code: self.country_code).first
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
    end

  end
end