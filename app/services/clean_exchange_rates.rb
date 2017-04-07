# frozen_string_literal: true

module CleanExchangeRates
  def self.call
    current = ExchangeRate.current
    return unless current
    ExchangeRate.where.not(id: current.id).destroy_all
  end
end
