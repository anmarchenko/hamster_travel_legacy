module Travels
  class Day < ActiveRecord::Base

    include Concerns::Copyable

    belongs_to :trip, class_name: 'Travels::Trip'

    has_many :places, class_name: 'Travels::Place'
    has_many :transfers, class_name: 'Travels::Transfer'
    has_one :hotel, class_name: 'Travels::Hotel'
    has_many :activities, class_name: 'Travels::Activity'
    has_many :expenses, class_name: 'Travels::Expense', as: :expendable

    default_scope ->{order(date_when: :asc)}

    before_save :init

    def init
      self.places = [Travels::Place.new] if self.places.count == 0
      self.hotel = Travels::Hotel.new if self.hotel.blank?
      self.expenses = [Travels::Expense.new] if self.expenses.count == 0
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

    def copied_relations
      ['places', 'transfers', 'hotel', 'activities', 'expenses']
    end

  end
end