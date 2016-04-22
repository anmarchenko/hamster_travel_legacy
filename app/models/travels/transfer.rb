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

    has_many :links, class_name: 'ExternalLink', as: :linkable

    monetize :amount_cents

    default_scope { includes(:city_from, :city_to) }

    before_save do |transfer|
      transfer.set_date(transfer.day.date_when)
    end

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
          FLIGHT => 'plane.svg',
          TRAIN => 'train.svg',
          TAXI => 'taxi.svg',
          BUS => 'bus.svg',
          BOAT => 'boat.svg',
          PERSONAL_CAR => 'car.svg'
      }
    end

    def city_from_text
      self.city_from.try(:translated_name, I18n.locale)
    end

    def city_to_text
      self.city_to.try(:translated_name, I18n.locale)
    end

    def type_icon
      icon = ActionController::Base.helpers.image_path("transfers/#{Types::ICONS[type]}") unless type.blank?
      icon = ActionController::Base.helpers.image_path("transfers/arrow.svg") if icon.blank?
      icon
    end

    def set_date! new_date
      self.set_date(new_date)
      self.save
    end

    def set_date new_date
      return if new_date.blank?
      self.start_time = self.start_time.change(day: new_date.day,
                                               year: new_date.year,
                                               month: new_date.month) if self.start_time.present?
      self.end_time = self.end_time.change(day: new_date.day,
                                           year: new_date.year,
                                           month: new_date.month) if self.end_time.present?
    end

    def serializable_hash(*args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['start_time'] = start_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00')
      json['end_time'] = end_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00')
      json['type_icon'] = type_icon
      json['amount_currency_text'] = amount.currency.symbol
      json['city_from_text'] = self.city_from_text
      json['city_to_text'] = self.city_to_text
      if links.blank?
        json['links'] = [{}]
      else
        json['links'] = links
      end
      json
    end

  end

end
