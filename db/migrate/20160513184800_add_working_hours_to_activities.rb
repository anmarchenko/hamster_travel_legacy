class AddWorkingHoursToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :working_hours, :string
  end
end
