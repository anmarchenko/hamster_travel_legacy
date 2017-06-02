# frozen_string_literal: true
class AddPlannedDaysCountToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :planned_days_count, :integer
  end
end
