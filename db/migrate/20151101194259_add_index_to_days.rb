class AddIndexToDays < ActiveRecord::Migration
  def change
    add_column :days, :index, :integer
  end
end
