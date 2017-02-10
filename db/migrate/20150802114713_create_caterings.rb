# frozen_string_literal: true
class CreateCaterings < ActiveRecord::Migration
  def change
    create_table :caterings do |t|
      t.string :city_code
      t.string :city_text
      t.text :description
      t.integer :days_count
      t.integer :persons_count
      t.belongs_to :trip, index: true
    end
  end
end
