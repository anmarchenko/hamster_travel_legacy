# frozen_string_literal: true
class AddRatesDateToExchangeRates < ActiveRecord::Migration[5.0]
  def change
    add_column :exchange_rates, :rates_date, :Date
  end
end
