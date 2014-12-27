module Db
  module Migrations

    class GeoPopulateNameSearch

      def self.perform
        [Geo::City, Geo::Adm3, Geo::Adm4, Geo::Adm5, Geo::Country, Geo::District, Geo::Region].each do |klass|
          p "Processing #{klass}"
          klass.all.each_with_index do |object, index|
            p "Process #{index} of #{klass}" if index % 200 == 0
            object.save
          end
        end
      end

    end

  end
end