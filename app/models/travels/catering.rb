# frozen_string_literal: true
# == Schema Information
#
# Table name: caterings
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  days_count      :integer
#  persons_count   :integer
#  trip_id         :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#  order_index     :integer
#

module Travels
  class Catering < ApplicationRecord
    include Concerns::Ordered

    belongs_to :trip, class_name: 'Travels::Trip'

    monetize :amount_cents

    def as_json(args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['amount_currency_text'] = amount.currency.symbol

      if args[:user_currency]
        Json::AmountUserCurrency.new(args[:user_currency]).call(json)
      end
      json
    end
  end
end
