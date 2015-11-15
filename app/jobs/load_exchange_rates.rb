class LoadExchangeRates
  @queue = :load_exchange_rates

  def self.perform
    @bank = Money.default_bank
    @bank.save_rates(ApplicationController::CACHE_RATES)
  end

end