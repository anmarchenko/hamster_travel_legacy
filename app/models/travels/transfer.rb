module Travels

  class Transfer
    include Mongoid::Document

    embedded_in :day, class_name: 'Travels::Day'

    module Types
      FLIGHT = 'flight'
      TRAIN = 'train'
      CAR = 'car'
      BUS = 'bus'
      BOAT = 'boat'

      ALL = [FLIGHT, TRAIN, CAR, BUS, BOAT]
      OPTIONS = ALL.map{|type| [I18n.t("common.#{type}"), type] }
      ICONS = {
          FLIGHT => 'map-icon-airport',
          TRAIN => 'map-icon-train-station',
          CAR => 'map-icon-taxi-stand',
          BUS => 'map-icon-bus-station',
          BOAT => 'map-icon-boat-tour'
      }
    end

    field :city_from_code
    field :city_from_text

    field :city_to_code
    field :city_to_text

    field :type
    field :type_icon
    def type_icon
      Types::ICONS[type] unless type.blank?
    end

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
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['start_time'] = start_time.try(:strftime, '%Y-%m-%dT%H:%MZ')
      json['end_time'] = end_time.try(:strftime, '%Y-%m-%dT%H:%MZ')
      json['type_icon'] = type_icon
      json
    end

  end

end