module Db
  module Migrations

    class GeoFixes2

      RUSSIA_GEONAMES_CODE = "2017370"
      RUSSIA_COUNTRY_CODE = "RU"

      KARACHAEVO_CHERKESIYA_GEONAMES_CODE = '552927'

      ULAN_UDE_GEONAMES_CODE = '2014407'
      NIZHNIY_GEONAMES_CODE = '520555'
      VORONEZH_GEONAMES_CODE = '472045'
      DEGUNINO_GEONAMES_CODE = '8505053'
      KRASNOGORSK_GEONAMES_CODE = '542374'
      IRKUTSK_GEONAMES_CODE = '2023469'
      TVER_GEONAMES_CODE = '480060'
      SAMARA_GEONAMES_CODE = '499099'
      PERM_GEONAMES_CODE = '511196'
      NOVOSIBIRSK_GEONAMES_CODE = '1496747'
      SALEKHARD_GEONAMES_CODE = '1493197'
      VLADIKAVKAZ_GEONAMES_CODE = '473249'
      VOLGOGRAD_GEONAMES_CODE = '472757'
      SYKTYVKAR_GEONAMES_CODE = '485239'

      BELARUS = '630336'
      SLOVAKIA = '3057568'
      THAILAND = '1605651'
      TAIWAN = '1668284'

      def self.perform
        kchr = Geo::Region.where(geonames_code: KARACHAEVO_CHERKESIYA_GEONAMES_CODE).first
        undenormalize(RUSSIA_COUNTRY_CODE, kchr.region_code)
        fix_city_name ULAN_UDE_GEONAMES_CODE
        fix_city_name NIZHNIY_GEONAMES_CODE
        fix_city_name VORONEZH_GEONAMES_CODE
        fix_city_name IRKUTSK_GEONAMES_CODE
        fix_city_name TVER_GEONAMES_CODE
        fix_city_name SAMARA_GEONAMES_CODE
        fix_city_name PERM_GEONAMES_CODE
        fix_city_name NOVOSIBIRSK_GEONAMES_CODE
        fix_city_name SALEKHARD_GEONAMES_CODE
        fix_city_name VLADIKAVKAZ_GEONAMES_CODE
        fix_city_name VOLGOGRAD_GEONAMES_CODE
        fix_city_name SYKTYVKAR_GEONAMES_CODE
        fix_country_name BELARUS
        fix_country_name SLOVAKIA
        fix_country_name THAILAND
        fix_country_name TAIWAN
      end

      def self.fix_country_name geonames_code
        country = Geo::Country.where(geonames_code: geonames_code).first
        undenormalize(country.country_code)
      end

      def self.fix_city_name geonames_code, country_code = RUSSIA_COUNTRY_CODE
        city = Geo::City.where(geonames_code: geonames_code).first
        undenormalize(RUSSIA_COUNTRY_CODE, city.region_code, city.geonames_code)
      end

      def self.undenormalize country_code = nil, region_code = nil, city_code = nil
        query = Geo::City.all
        query = query.where(country_code: country_code) unless country_code.blank?
        query = query.where(region_code: region_code) unless region_code.blank?
        query = query.where(geonames_code: city_code) unless city_code.blank?
        query.each do |city|
          city.set(denormalized: false)
        end
      end

    end

  end
end