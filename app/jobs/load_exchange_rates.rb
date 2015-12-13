class LoadExchangeRates
  @queue = :load_exchange_rates

  def self.perform
    current_rates = ExchangeRate.current
    return if current_rates && current_rates.rates_date == Time.zone.today
    bank = Money.default_bank
    eu_file = bank.save_rates_to_s
    bank.update_rates_from_s eu_file
    ExchangeRate.create(eu_file: eu_file, rates_date: bank.rates_updated_at)
  end

end