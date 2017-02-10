# frozen_string_literal: true
class AddPriceToCatering < ActiveRecord::Migration
  def change
    add_monetize :caterings, :price
  end
end
