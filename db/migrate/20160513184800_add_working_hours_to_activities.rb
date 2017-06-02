# frozen_string_literal: true
class AddWorkingHoursToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :working_hours, :string
  end
end
