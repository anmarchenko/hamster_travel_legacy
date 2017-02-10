# frozen_string_literal: true
class AddPlannedDaysCountToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :planned_days_count, :integer
  end
end
