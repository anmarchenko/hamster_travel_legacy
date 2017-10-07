# frozen_string_literal: true

module LoadExchangeRates
  def self.call
    current_rates = ExchangeRate.current
    return if current_rates&.rates_date == Time.zone.today
    bank = Money.default_bank
    eu_file = bank.save_rates_to_s
    bank.update_rates_from_s eu_file
    ExchangeRate.create(eu_file: eu_file, rates_date: bank.rates_updated_at)

    # invalidate caches for all trips
    Travels::Trip.relevant.find_each do |trip|
      Budgets.on_budget_change(trip)
    end
  end
end
