class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :order_index, index: true

      t.string :city_from_code
      t.string :city_from_text
      t.string :city_to_code
      t.string :city_to_text
      t.string :type
      t.string :type_icon
      t.string :code
      t.string :company
      t.string :link
      t.string :station_from
      t.string :station_to
      t.datetime :start_time
      t.datetime :end_time
      t.text :comment
      t.integer :price
      t.string :mongo_id

      t.belongs_to :day, index: true
    end
  end
end
