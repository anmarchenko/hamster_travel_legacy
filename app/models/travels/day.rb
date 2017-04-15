# frozen_string_literal: true

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

    default_scope(-> { order(date_when: :asc, index: :asc) })

    before_create :init
    def init
      self.places = [Travels::Place.new] if places.blank?
      if hotel.blank?
        self.hotel = Travels::Hotel.new(amount_currency: trip.currency)
      end
      return unless expenses.blank?
      self.expenses = [Travels::Expense.new(amount_currency: trip.currency)]
    end

    def date_when_s
      return I18n.l(date_when, format: '%d.%m.%Y %A') unless date_when.blank?
      I18n.t('common.day_number', number: index + 1)
    end

    def empty_content?
      %i[transfers activities comment].each do |field|
        return false unless send(field).blank?
      end
      return false unless places_empty?
      return false unless expenses_empty?
      hotel.blank? || hotel.empty_content?
    end

    def places_empty?
      (places || []).each do |place|
        return false unless place.empty_content?
      end
      true
    end

    def expenses_empty?
      (expenses || []).each do |expense|
        return false unless expense.empty_content?
      end
      true
    end

    def as_json(args = {})
      super.merge('date' => date_when_s, 'id' => id.to_s)
    end
  end
end
