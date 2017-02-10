# frozen_string_literal: true
class RemovePriceFromExpenses < ActiveRecord::Migration
  def change
    remove_column :expenses, :price
  end
end
