module Db
  module Migrations

    class ZipImages
      def self.perform
        Travels::Trip.all.each do |trip|
          next if trip.image.blank?
          trip.image = trip.image.thumb('300x300')
          trip.save
        end
        User.all.each do |user|
          next if user.image.blank?
          user.image = user.image.thumb('100x100')
          user.save
        end
      end
    end

  end
end