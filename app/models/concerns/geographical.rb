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
      field :country_text, type: String

      field :region_code, type: String
      field :region_text, type: String

      field :district_code, type: String
      field :district_text, type: String

      field :adm3_code, type: String
      field :adm3_text, type: String

      field :adm4_code, type: String
      field :adm4_text, type: String

      field :adm5_code, type: String
      field :adm5_text, type: String

      field :timezone_text, type: String
      field :timezone_code, type: String
    end

    def translated_name(locale = I18n.locale)
      ::Geo::GeoName.where(geonames_id: self.geonames_code, locale: locale).first.try(:name) || name
    end

    def country
      ::Geo::Country.where(geonames_code: self.country_code).first
    end

    def region
      ::Geo::Region.where(geonames_code: self.region_code).first
    end

    def district
      ::Geo::District.where(geonames_code: self.district_code).first
    end

    def adm4
      ::Geo::Adm4.where(geonames_code: self.adm4_code).first
    end

    def adm5
      ::Geo::Adm5.where(geonames_code: self.adm5_code).first
    end

    module ClassMethods
    end

  end
end