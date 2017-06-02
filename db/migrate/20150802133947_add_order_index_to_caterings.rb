# frozen_string_literal: true
class AddOrderIndexToCaterings < ActiveRecord::Migration[5.0]
  def change
    add_column :caterings, :order_index, :integer
  end
end
