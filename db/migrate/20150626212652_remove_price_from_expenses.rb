# frozen_string_literal: true
class RemovePriceFromExpenses < ActiveRecord::Migration[5.0]
  def change
    remove_column :expenses, :price
  end
end
