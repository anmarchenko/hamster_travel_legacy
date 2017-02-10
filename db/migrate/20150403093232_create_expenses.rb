# frozen_string_literal: true
class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :name
      t.integer :price
      t.string :mongo_id

      t.references :expendable, polymorphic: true, index: true
    end
  end
end
