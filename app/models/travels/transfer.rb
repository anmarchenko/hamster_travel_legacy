# == Schema Information
#
# Table name: transfers
#
#  id              :integer          not null, primary key
#  order_index     :integer
#  type            :string
#  type_icon       :string
#  code            :string
#  company         :string
#  link            :string
#  station_from    :string
#  station_to      :string
#  start_time      :datetime
#  end_time        :datetime
#  comment         :text
#  mongo_id        :string
#  day_id          :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#  city_to_id      :integer
#  city_from_id    :integer
#

module Travels

  class Transfer < ActiveRecord::Base
    include Concerns::Ordered
    include Concerns::Copyable

    self.inheritance_column = 'inherit_type'

    belongs_to :day, class_name: 'Travels::Day'
    belongs_to :city_from, class_name: 'Geo::City', required: false
    belongs_to :city_to, class_name: 'Geo::City', required: false

    monetize :amount_cents

    default_scope { includes(:city_from, :city_to) }

    module Types
      FLIGHT = 'flight'
      TRAIN = 'train'
      TAXI = 'car'
      PERSONAL_CAR = 'personal_car'
      BUS = 'bus'
      BOAT = 'boat'

      ALL = [FLIGHT, TRAIN, TAXI, BUS, BOAT, PERSONAL_CAR]
      OPTIONS = ALL.map { |type| ["common.#{type}", type] }
      ICONS = {
          FLIGHT => 'fa fa-plane',
          TRAIN => 'fa fa-train',
          TAXI => 'fa fa-taxi',
          BUS => 'fa fa-bus',
          BOAT => 'fa fa-ship',
          PERSONAL_CAR => 'fa fa-car'
      }
    end

    def city_from_text
      self.city_from.try(:translated_name, I18n.locale)
    end

    def city_to_text
      self.city_to.try(:translated_name, I18n.locale)
    end

    def type_icon
      Types::ICONS[type] unless type.blank?
    end

    def set_date! new_date
      return if self.start_time.blank? && self.end_time.blank?
      days_period = (end_time.to_date - start_time.to_date).to_i
      new_end_date = new_date + days_period.days

      self.start_time = self.start_time.change(day: new_date.day, year: new_date.year, month: new_date.month)
      self.end_time = self.end_time.change(day: new_end_date.day,
                                           year: new_end_date.year,
                                           month: new_end_date.month)
      self.save
    end

    def as_json(*args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['start_time'] = start_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00')
      json['end_time'] = end_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00')
      json['type_icon'] = type_icon
      json['amount_cents'] = amount_cents / 100
      json['amount_currency_text'] = amount.currency.symbol
      json['city_from_text'] = self.city_from_text
      json['city_to_text'] = self.city_to_text
      json
    end

  end

end
