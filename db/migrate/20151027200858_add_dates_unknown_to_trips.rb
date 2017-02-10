# frozen_string_literal: true
class AddDatesUnknownToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :dates_unknown, :boolean
  end
end
