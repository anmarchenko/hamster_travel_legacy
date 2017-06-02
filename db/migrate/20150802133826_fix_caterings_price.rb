# frozen_string_literal: true
class FixCateringsPrice < ActiveRecord::Migration[5.0]
  def change
    rename_column :caterings, :price_cents, :amount_cents
    rename_column :caterings, :price_currency, :amount_currency
  end
end
