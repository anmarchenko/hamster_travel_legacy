class FixCateringsPrice < ActiveRecord::Migration
  def change
    rename_column :caterings, :price_cents, :amount_cents
    rename_column :caterings, :price_currency, :amount_currency
  end
end
