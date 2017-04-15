# frozen_string_literal: true

module CurrencyHelper
  DEFAULT_CURRENCY = 'EUR'
  IMPORTANT_CURRENCIES = %w[RUB EUR USD GBP].freeze
  ECB_CURRENCIES = (EuCentralBank::CURRENCIES.dup + ['EUR']).freeze

  def self.currency_list(user_currency = nil, trip_currency = nil)
    res = ECB_CURRENCIES.sort_by do |curr|
      currency_value(curr, user_currency, trip_currency)
    end
    res.map { |curr| Money::Currency.find(curr) }
  end

  def self.currency_value(currency, user_currency = nil, trip_currency = nil)
    if currency == user_currency
      [-9, currency]
    elsif currency == trip_currency
      [-10, currency]
    elsif IMPORTANT_CURRENCIES.include?(currency)
      [-1, currency]
    else
      [0, currency]
    end
  end

  def self.currencies_select(user_currency = nil, trip_currency = nil)
    CurrencyHelper.currency_list(user_currency, trip_currency).map do |currency|
      [
        "#{currency.name} (#{currency.iso_code})",
        currency.iso_code, currency.symbol
      ]
    end
  end

  def self.currencies_select_simple(user_currency = nil)
    CurrencyHelper.currency_list(user_currency).map do |currency|
      ["#{currency.name} (#{currency.iso_code})", currency.iso_code]
    end
  end
end
