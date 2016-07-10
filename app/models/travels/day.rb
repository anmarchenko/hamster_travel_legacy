# == Schema Information
#
# Table name: days
#
#  id        :integer          not null, primary key
#  date_when :date
#  comment   :text
#  trip_id   :integer
#  index     :integer
#

module Travels
  class Day < ApplicationRecord

    belongs_to :trip, class_name: 'Travels::Trip'

    has_many :places, class_name: 'Travels::Place'
    has_many :transfers, class_name: 'Travels::Transfer'
    has_one :hotel, class_name: 'Travels::Hotel'
    has_many :activities, class_name: 'Travels::Activity'
    has_many :expenses, class_name: 'Travels::Expense', as: :expendable
    has_many :links, class_name: 'ExternalLink', as: :linkable

    default_scope ->{order(date_when: :asc, index: :asc)}

    before_create :init
    def init
      self.places = [Travels::Place.new] if self.places.blank?
      self.hotel = Travels::Hotel.new(amount_currency: trip.currency) if self.hotel.blank?
      self.expenses = [Travels::Expense.new(amount_currency: trip.currency)] if self.expenses.blank?
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

    def as_json(args = {})
      json = super(args)
      json['id'] = id.to_s
      json['date'] = date_when_s

      unless args[:normal_json]
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
      end

      json
    end

    def short_hash
      transfer = self.transfers.first
      transfer_s = "#{transfer.city_from_text} - #{transfer.city_to_text}" if transfer
      # first 3 activities by rating
      activity_s = ""
      self.activities.unscoped.where(day_id: self.id)
          .order({rating: :desc, order_index: :asc})
          .first(3).each_with_index do |activity, index|
        activity_s += "#{index + 1}. #{activity.name}"
        activity_s += "<br/>"
      end
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
