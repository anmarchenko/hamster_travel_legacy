# frozen_string_literal: true
class CreateExchangeRates < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
      t.text :eu_file

      t.timestamps null: false
    end
  end
end
