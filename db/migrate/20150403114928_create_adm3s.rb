# frozen_string_literal: true
class CreateAdm3s < ActiveRecord::Migration[5.0]
  def change
    create_table :adm3s do |t|
      t.string :geonames_code, index: true
      t.date :geonames_modification_date

      t.string :name
      t.string :name_ru
      t.string :name_en

      t.float :latitude
      t.float :longitude

      t.integer :population, index: true

      t.string :country_code
      t.string :region_code
      t.string :district_code
      t.string :adm3_code
      t.string :adm4_code
      t.string :adm5_code

      t.string :timezone

      t.string :mongo_id
    end
  end
end
