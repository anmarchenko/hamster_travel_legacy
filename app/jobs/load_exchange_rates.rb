class LoadExchangeRates
  @queue = :load_exchange_rates

  def self.perform
    current_rates = ExchangeRate.current
    return if current_rates && current_rates.rates_date == Date.today
    bank = Money.default_bank
    eu_file = bank.save_rates_to_s
    ExchangeRate.create(eu_file: eu_file, rates_date: Date.today)
  end

end