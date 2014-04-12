module Db
  module Migrations

    class DefaultUsersHometown

      def self.perform
        moscow = Geo::City.where(status: Geo::City::Statuses::CAPITAL, country_code: 'RU').first
        puts 'WHAT??? no moscow' and return if moscow.blank?
        User.all.each do |user|
          user.home_town_code = moscow.geonames_code
          user.home_town_text = moscow.translated_name('ru')
          user.save
        end
      end

    end

  end
end