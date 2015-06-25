module CurrencyHelper

  DEFAULT_CURRENCY = 'RUB'

  IMPORTANT_CURRENCIES = %w(RUB EUR USD GBP)

  def self.currency_list user_currency = nil, trip_currency = nil
    ecb_currencies = EuCentralBank::CURRENCIES.clone
    ecb_currencies << 'EUR'

    ecb_currencies.sort_by! do |curr|
      if curr == user_currency
        [-9, curr]
      elsif curr == trip_currency
        [-10, curr]
      elsif IMPORTANT_CURRENCIES.include?(curr)
        [-1, curr]
      else
        [0, curr]
      end
    end
    ecb_currencies.map{|curr| Money::Currency.select{|c| c.iso_code == curr }.first}
  end

  def self.currencies_select user_currency = nil, trip_currency = nil
    CurrencyHelper.currency_list(user_currency, trip_currency).map do |currency|
      ["#{currency.name} (#{currency.iso_code})",currency.iso_code, currency.symbol]
    end
  end


end