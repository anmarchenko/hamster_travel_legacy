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
#  mongo_id                   :string
#

module Geo
  class City < ActiveRecord::Base

    include Concerns::Geographical

    translates :name, :fallbacks_for_empty_translations => true

    module Statuses
      CAPITAL = 'capital'
      REGION_CENTER = 'region_center'
      DISTRICT_CENTER = 'district_center'
      ADM3_CENTER = 'adm3_center'
      ADM4_CENTER = 'adm4_center'
      ADM5_CENTER = 'adm5_center'
    end

    def translated_text(args = {with_region: true, with_country: true, locale: I18n.locale})
      text = translated_name(args[:locale])
      if args[:with_region]
        reg = self.region.try(:translated_name, args[:locale])
        text += ", #{reg}" unless reg.blank? or reg == text
      end
      if args[:with_country]
        c = self.country.try(:translated_name, args[:locale])
        text += ", #{c}" unless c.blank?
      end
      text
    end

    def is_capital?
      status == Statuses::CAPITAL
    end

    def is_region_center?
      status == Statuses::REGION_CENTER
    end

    def is_district_center?
      status == Statuses::DISTRICT_CENTER
    end

    def is_adm3_center?
      status == Statuses::ADM3_CENTER
    end

    def is_adm4_center?
      status == Statuses::ADM4_CENTER
    end

    def is_adm5_center?
      status == Statuses::ADM5_CENTER
    end

    def update_from_geonames_string(str)
      super(str)
      values = Geo::City.split_geonames_string(str)
      feature_code = values[7].strip
      case feature_code
        when 'PPLC'
          self.status = Statuses::CAPITAL
        when 'PPLA'
          self.status = Statuses::REGION_CENTER
        when 'PPLA2'
          self.status = Statuses::DISTRICT_CENTER
        when 'PPLA3'
          self.status = Statuses::ADM3_CENTER
        when 'PPLA4'
          self.status = Statuses::ADM4_CENTER
      end
      save
    end

    def self.find_by_term(term)
      term = Regexp.escape(term)
      self.all.with_translations.where("\"city_translations\".\"name\" ILIKE ?", "#{term}%").order(population: :desc)
    end

  end
end
