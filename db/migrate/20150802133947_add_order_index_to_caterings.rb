class AddOrderIndexToCaterings < ActiveRecord::Migration
  def change
    add_column :caterings, :order_index, :integer
  end
end
