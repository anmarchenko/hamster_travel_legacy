# frozen_string_literal: true
class RemoveCodesFromEverywhere < ActiveRecord::Migration
  def change
    remove_column(:places, :city_code)
    remove_column(:transfers, :city_from_code)
    remove_column(:transfers, :city_to_code)
    remove_column(:users, :home_town_code)
  end
end
