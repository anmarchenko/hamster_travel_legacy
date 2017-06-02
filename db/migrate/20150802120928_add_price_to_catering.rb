# frozen_string_literal: true
class AddPriceToCatering < ActiveRecord::Migration[5.0]
  def change
    add_monetize :caterings, :price
  end
end
