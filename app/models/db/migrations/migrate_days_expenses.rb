module Db
  module Migrations

    class MigrateDaysExpenses
      def self.perform
        Travels::Trip.all.each do |trip|
          trip.days.each do |day|
            next unless day.expenses.blank?
            if day.add_price.blank?
              day.expenses.create({})
            else
              day.expenses.create({price: day.add_price})
            end
          end
        end
      end
    end

  end
end