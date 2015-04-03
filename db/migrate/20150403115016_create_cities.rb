class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
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

      t.string :status

      t.string :country_text
      t.string :country_text_ru
      t.string :country_text_en

      t.string :region_text
      t.string :region_text_ru
      t.string :region_text_en

      t.boolean :denormalized, default: false

      t.string :mongo_id
    end
  end
end
