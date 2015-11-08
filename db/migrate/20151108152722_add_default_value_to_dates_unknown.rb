class AddDefaultValueToDatesUnknown < ActiveRecord::Migration
  def change
    change_column :trips, :dates_unknown, :boolean, default: false
  end
end
