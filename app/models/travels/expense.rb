# == Schema Information
#
# Table name: expenses
#
#  id              :integer          not null, primary key
#  name            :string
#  mongo_id        :string
#  expendable_id   :integer
#  expendable_type :string
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#

module Travels

  class Expense < ActiveRecord::Base
    include Concerns::Copyable

    belongs_to :expendable, polymorphic: true

    monetize :amount_cents

    def is_empty?
      return (amount_cents.blank? || amount_cents == 0) && name.blank?
    end

    def serializable_hash(*args)
      json = super(except: [:_id])
      json['id'] = id.to_s

      json['name'] = name

      json['amount_currency'] = amount_currency
      json['amount_currency_text'] = amount.currency.symbol
      json
    end

  end

end
