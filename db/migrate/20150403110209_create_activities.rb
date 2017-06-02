# frozen_string_literal: true
class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.integer :order_index, index: true
      t.string :name
      t.integer :price
      t.text :comment
      t.string :link_description
      t.text :link_url
      t.string :mongo_id

      t.belongs_to :day, index: true
    end
  end
end
