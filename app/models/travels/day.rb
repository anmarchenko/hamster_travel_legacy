module Travels
  class Day

    include Mongoid::Document

    embedded_in :trip, class_name: 'Travels::Trip'

    field :date_when, type: Date

    embeds_many :places, class_name: 'Travels::Place'
    embeds_many :transfers, class_name: 'Travels::Transfer'
    embeds_one :hotel, class_name: 'Travels::Hotel'
    embeds_many :activities, class_name: 'Travels::Activity'

    field :comment, type: String
    field :add_price, type: Integer

    before_save :init

    def init
      self.places = [Travels::Place.new] if self.places.blank?
      self.hotel = Travels::Hotel.new if self.hotel.blank?
    end

    def date_when_s
      I18n.l(date_when, format: '%d.%m.%Y %A') unless date_when.blank?
    end

    def is_empty?
      [:transfers, :activities, :comment, :add_price].each do |field|
        return false unless self.send(field).blank?
      end
      (self.places || []).each do |place|
        return false unless place.is_empty?
      end
      return hotel.blank? || hotel.is_empty?
    end

    def as_json(**args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['date'] = date_when_s
      json['transfers'] = transfers.as_json(args)
      json['activities'] = activities.as_json(args)
      json['places'] = places.as_json(args)
      json['hotel'] = hotel.as_json(args)
      json
    end

  end
end