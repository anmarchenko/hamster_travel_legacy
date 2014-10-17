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
    embeds_many :expenses, class_name: 'Travels::Expense', as: :expendable

    # old field, only for backward compatibility
    field :add_price, type: Integer

    before_save :init

    def init
      self.places = [Travels::Place.new] if self.places.blank?
      self.hotel = Travels::Hotel.new if self.hotel.blank?
      self.expenses = [Travels::Expense.new] if self.expenses.blank?
    end

    def date_when_s
      I18n.l(date_when, format: '%d.%m.%Y %A') unless date_when.blank?
    end

    def is_empty?
      [:transfers, :activities, :comment].each do |field|
        return false unless self.send(field).blank?
      end
      (self.places || []).each do |place|
        return false unless place.is_empty?
      end
      (self.expenses || []).each do |expense|
        return false unless expense.is_empty?
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
      json['expenses'] = expenses.as_json(args)
      json
    end

    def attributes_for_clone
      res = attributes
      # clean attributes
      (res['places'] || []).each{ |h| h.reject!{|k, _| !Travels::Place.fields.keys.include?(k)} }
      (res['transfers'] || []).each{ |h| h.reject!{|k, _| !Travels::Transfer.fields.keys.include?(k)} }
      (res['activities'] || []).each{ |h| h.reject!{|k, _| !Travels::Activity.fields.keys.include?(k)} }
      (res['expenses'] || []).each{ |h| h.reject!{|k, _| !Travels::Expense.fields.keys.include?(k)} }
      (res['hotel'] || {}).reject! {|k, _| !(Travels::Hotel.fields.keys + ['links']).include?(k)}
      res
    end

  end
end