# == Schema Information
#
# Table name: days
#
#  id        :integer          not null, primary key
#  mongo_id  :string
#  date_when :date
#  comment   :text
#  trip_id   :integer
#  index     :integer
#

module Travels
  class Day < ActiveRecord::Base

    include Concerns::Copyable

    belongs_to :trip, class_name: 'Travels::Trip'

    has_many :places, class_name: 'Travels::Place'
    has_many :transfers, class_name: 'Travels::Transfer'
    has_one :hotel, class_name: 'Travels::Hotel'
    has_many :activities, class_name: 'Travels::Activity'
    has_many :expenses, class_name: 'Travels::Expense', as: :expendable
    has_many :links, class_name: 'ExternalLink', as: :linkable

    default_scope ->{order(date_when: :asc, index: :asc)}

    # TODO: performance issue
    before_save :init

    def init
      self.places = [Travels::Place.new] if self.places.count == 0
      self.hotel = Travels::Hotel.new(amount_currency: trip.currency) if self.hotel.blank?
      self.expenses = [Travels::Expense.new(amount_currency: trip.currency)] if self.expenses.count == 0
    end

    def date_when_s
      return I18n.l(date_when, format: '%d.%m.%Y %A') unless date_when.blank?
      I18n.t('common.day_number', number: self.index + 1)
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
      if links.blank?
        json['links'] = [ExternalLink.new].as_json(args)
      else
        json['links'] = links.as_json(args)
      end
      json
    end

    def copied_relations
      ['places', 'transfers', 'hotel', 'activities', 'expenses']
    end

    def short_hash
      transfer = self.transfers.first
      transfer_s = "#{transfer.city_from_text} - #{transfer.city_to_text}" if transfer
      activity = self.activities.first
      activity_s = "#{activity.name}" if activity
      place = self.places.first
      place_s = place.city_text if place
      {
          id: self.id.to_s,
          date: self.date_when,
          index: self.index,
          transfer_s: transfer_s,
          activity_s: activity_s,
          place_s: place_s
      }
    end

  end
end
