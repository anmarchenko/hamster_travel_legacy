module Travels

  class Transfer
    include Mongoid::Document

    embedded_in :day, class_name: 'Travels::Day'

    module Types
      FLIGHT = 'flight'
      TRAIN = 'train'
      CAR = 'car'
      BUS = 'bus'
      TRAM = 'tram'

      ALL = [FLIGHT, TRAIN, CAR, BUS, TRAM]
      OPTIONS = ALL.map{|type| [I18n.t("common.#{type}"), type] }
    end

    field :city_from_code
    field :city_from_text

    field :city_to_code
    field :city_to_text

    field :type

    field :code
    field :company

    field :link

    field :station_from
    field :station_to

    field :start_time, type: DateTime
    field :end_time, type: DateTime

    field :comment

    field :price, type: Integer

    def city_from
      ::Geo::City.by_geonames_code(city_from_code)
    end

    def city_to
      ::Geo::City.by_geonames_code(city_to_code)
    end

    def as_json(*args)
      {
          id: id.to_s,
          city_from_code: city_from_code,
          city_from_text: city_from_text,
          city_to_code: city_to_code,
          city_to_text: city_to_text,
          type: type,
          code: code,
          company: company,
          link: link,
          station_from: station_from,
          station_to: station_to,
          start_time: start_time.try(:strftime, '%Q'),
          end_time: end_time.try(:strftime, '%Q'),
          comment: comment,
          price: price
      }
    end

  end

end