module Travels

  class Expense < ActiveRecord::Base
    include Concerns::Copyable

    belongs_to :expendable, polymorphic: true

    monetize :amount_cents

    def is_empty?
      return (amount_cents.blank? || amount_cents == 0) && name.blank?
    end

    def as_json(*args)
      json = super(except: [:_id])
      json['id'] = id.to_s

      json['name'] = name

      json['amount_cents'] = amount_cents / 100
      json['amount_currency'] = amount_currency
      json['amount_currency_text'] = amount.currency.symbol
      json
    end

  end

end