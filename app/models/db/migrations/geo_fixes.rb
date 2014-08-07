module Db
  module Migrations

    class GeoFixes

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
        # Карачаево-Черкесия
        kchr = Geo::Region.where(geonames_code: KARACHAEVO_CHERKESIYA_GEONAMES_CODE).first
        kchr.set(name_ru: 'Республика Карачаево-Черкесия')
        undenormalize(RUSSIA_COUNTRY_CODE, kchr.region_code)

        # Центр Московской области - Красногорск
        Geo::City.where(geonames_code: DEGUNINO_GEONAMES_CODE).find_and_modify("$set" => {status: nil})
        Geo::City.where(geonames_code: KRASNOGORSK_GEONAMES_CODE)
        .find_and_modify("$set" => {status: Geo::City::Statuses::REGION_CENTER})

        fix_city_name ULAN_UDE_GEONAMES_CODE, 'Улан-Удэ'
        fix_city_name NIZHNIY_GEONAMES_CODE, 'Нижний Новгород'
        fix_city_name VORONEZH_GEONAMES_CODE, 'Воронеж'
        fix_city_name IRKUTSK_GEONAMES_CODE, 'Иркутск'
        fix_city_name TVER_GEONAMES_CODE, 'Тверь'
        fix_city_name SAMARA_GEONAMES_CODE, 'Самара'
        fix_city_name PERM_GEONAMES_CODE, 'Пермь'
        fix_city_name NOVOSIBIRSK_GEONAMES_CODE, 'Новосибирск'
        fix_city_name SALEKHARD_GEONAMES_CODE, 'Салехард'
        fix_city_name VLADIKAVKAZ_GEONAMES_CODE, 'Владикавказ'
        fix_city_name VOLGOGRAD_GEONAMES_CODE, 'Волгоград'
        fix_city_name SYKTYVKAR_GEONAMES_CODE, 'Сыктывкар'

        fix_country_name BELARUS, 'Беларусь'
        fix_country_name SLOVAKIA, 'Словакия'
        fix_country_name THAILAND, 'Таиланд'
        fix_country_name TAIWAN, 'Тайвань'
      end

      def self.fix_country_name geonames_code, new_name
        country = Geo::Country.where(geonames_code: geonames_code).first
        country.set(name_ru: new_name)
        undenormalize(country.geonames_code)
      end

      def self.fix_city_name geonames_code, new_name, country_code = RUSSIA_COUNTRY_CODE
        city = Geo::City.where(geonames_code: geonames_code).first
        city.set(name_ru: new_name)
        undenormalize(RUSSIA_COUNTRY_CODE, city.region_code, city.geonames_code)
      end

      def self.undenormalize country_code = nil, region_code = nil, city_code = nil
        query = Geo::City.all
        query = query.where(country_code: country_code) unless country_code.blank?
        query = query.where(region_code: region_code) unless region_code.blank?
        query = query.where(geonames_code: city_code) unless city_code.blank?
        query.find_and_modify("$set" => {denormalized: false})
      end

    end

  end
end