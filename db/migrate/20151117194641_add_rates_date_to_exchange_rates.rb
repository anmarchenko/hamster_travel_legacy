# frozen_string_literal: true
class AddRatesDateToExchangeRates < ActiveRecord::Migration
  def change
    add_column :exchange_rates, :rates_date, :Date
  end
end
