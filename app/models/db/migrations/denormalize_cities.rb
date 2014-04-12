module Db
  module Migrations
    class DenormalizeCities

      def self.perform
        Geo::City.all.each do |city|
          city.country_text = city.country.try(:name)
          city.country_text_ru = city.country.try(:name_ru)
          city.country_text_en = city.country.try(:name_en)

          city.region_text = city.region.try(:name)
          city.region_text_ru = city.region.try(:name_ru)
          city.region_text_en = city.region.try(:name_en)

          city.save
        end
      end

    end
  end
end