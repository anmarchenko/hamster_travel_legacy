# frozen_string_literal: true

module CleanExchangeRates
  module_function

  def call
    current = ExchangeRate.current
    return unless current
    ExchangeRate.where.not(id: current.id).destroy_all
  end
end
