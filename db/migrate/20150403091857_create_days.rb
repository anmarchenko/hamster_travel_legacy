# frozen_string_literal: true
class CreateDays < ActiveRecord::Migration[5.0]
  def change
    create_table :days do |t|
      t.string :mongo_id
      t.date :date_when
      t.text :comment

      t.belongs_to :trip, index: true
    end
  end
end
