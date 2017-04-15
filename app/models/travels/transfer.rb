# frozen_string_literal: true

# == Schema Information
#
# Table name: transfers
#
#  id              :integer          not null, primary key
#  order_index     :integer
#  type            :string
#  code            :string
#  company         :string
#  link            :string
#  station_from    :string
#  station_to      :string
#  start_time      :datetime
#  end_time        :datetime
#  comment         :text
#  day_id          :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#  city_to_id      :integer
#  city_from_id    :integer
#

module Travels
  class Transfer < ApplicationRecord
    include Concerns::Ordered

    self.inheritance_column = 'inherit_type'

    belongs_to :day, class_name: 'Travels::Day'
    belongs_to :city_from, class_name: 'Geo::City', required: false
    belongs_to :city_to, class_name: 'Geo::City', required: false

    has_many :links, class_name: 'ExternalLink', as: :linkable

    monetize :amount_cents

    module Types
      FLIGHT = 'flight'
      TRAIN = 'train'
      TAXI = 'car'
      PERSONAL_CAR = 'personal_car'
      BUS = 'bus'
      BOAT = 'boat'

      ALL = [FLIGHT, TRAIN, TAXI, BUS, BOAT, PERSONAL_CAR].freeze
      OPTIONS = ALL.map { |type| ["common.#{type}", type] }
      ICONS = {
        FLIGHT => 'plane.svg',
        TRAIN => 'train.svg',
        TAXI => 'taxi.svg',
        BUS => 'bus.svg',
        BOAT => 'boat.svg',
        PERSONAL_CAR => 'car.svg'
      }.freeze
    end

    def city_from_text
      city_from&.translated_name I18n.locale
    end

    def city_to_text
      city_to&.translated_name I18n.locale
    end

    # TODO: warning: model should not call view directly
    def type_icon
      unless type.blank?
        icon = ActionController::Base.helpers.image_path(
          "transfers/#{Types::ICONS[type]}"
        )
      end
      icon ||= ActionController::Base.helpers.image_path('transfers/arrow.svg')
      icon
    end

    # TODO: warning: model should not call view directly
    def serializable_hash(**args)
      Views::TransferView.show_json(self, super)
    end
  end
end
