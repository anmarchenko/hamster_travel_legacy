# frozen_string_literal: true
class AddDatesUnknownToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :dates_unknown, :boolean
  end
end
