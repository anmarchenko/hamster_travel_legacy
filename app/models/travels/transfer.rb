module Travels

  class Transfer < ActiveRecord::Base
    include Concerns::Ordered
    include Concerns::Copyable

    self.inheritance_column = 'inherit_type'

    belongs_to :day, class_name: 'Travels::Day'

    module Types
      FLIGHT = 'flight'
      TRAIN = 'train'
      TAXI = 'car'
      PERSONAL_CAR = 'personal_car'
      BUS = 'bus'
      BOAT = 'boat'

      ALL = [FLIGHT, TRAIN, TAXI, BUS, BOAT, PERSONAL_CAR]
      OPTIONS = ALL.map{|type| [I18n.t("common.#{type}"), type] }
      ICONS = {
          FLIGHT => 'map-icon-airport',
          TRAIN => 'map-icon-train-station',
          TAXI => 'map-icon-taxi-stand',
          BUS => 'map-icon-bus-station',
          BOAT => 'map-icon-boat-tour',
          PERSONAL_CAR => 'map-icon-car-rental'
      }
    end

    def type_icon
      Types::ICONS[type] unless type.blank?
    end

    def city_from
      ::Geo::City.by_geonames_code(city_from_code)
    end

    def city_to
      ::Geo::City.by_geonames_code(city_to_code)
    end

    def as_json(*args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['start_time'] = start_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00')
      json['end_time'] = end_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00')
      json['type_icon'] = type_icon
      json
    end

  end

end