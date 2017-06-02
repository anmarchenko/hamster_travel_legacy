# frozen_string_literal: true
class AddIndexToDays < ActiveRecord::Migration[5.0]
  def change
    add_column :days, :index, :integer
  end
end
