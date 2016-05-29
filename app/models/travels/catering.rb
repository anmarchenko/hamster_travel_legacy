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
  class Catering < ActiveRecord::Base
    include Concerns::Ordered

    belongs_to :trip, class_name: 'Travels::Trip'

    monetize :amount_cents

    def as_json(_args)
      json = super(except: [:_id])
      json['id'] = id.to_s
      json['amount_currency_text'] = amount.currency.symbol
      json
    end

  end
end
