module Db
  module Migrations

    class SetPrivateToTrips
      def self.perform
        Travels::Trip.all.each do |trip|
          trip.set(private: false)
        end
      end
    end

  end
end