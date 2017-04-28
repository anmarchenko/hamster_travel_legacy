# frozen_string_literal: true

module Amounts
  def self.from_frontend(cents, currency_code)
    Money.new(
      (cents * Money::Currency.new(currency_code).subunit_to_unit) / 100,
      currency_code
    )
  end

  def self.to_frontend(amount)
    amount.cents * (100 / amount.currency.subunit_to_unit)
  end
end
