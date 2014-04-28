module Travels
  class Place
    include Mongoid::Document

    embedded_in :day, class_name: 'Travels::Day'

    field :city_code
    field :city_text

    def city
      Geo::City.by_geonames_code(city_code)
    end

    def as_json(*args)
      {
          id: id.to_s,
          city_code: city_code,
          city_text: city_text
      }
    end

  end
end