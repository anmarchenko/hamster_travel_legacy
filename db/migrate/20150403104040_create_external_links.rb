# frozen_string_literal: true
class CreateExternalLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :external_links do |t|
      t.string :description
      t.text :url
      t.string :mongo_id

      t.references :linkable, polymorphic: true, index: true
    end
  end
end
