# frozen_string_literal: true
class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string :name
      t.integer :price
      t.text :comment
      t.string :mongo_id

      t.belongs_to :day, index: true
    end
  end
end
