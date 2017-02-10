# frozen_string_literal: true
class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :city_code
      t.string :city_text
      t.string :mongo_id

      t.belongs_to :day, index: true
    end
  end
end
