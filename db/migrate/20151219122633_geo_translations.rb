# frozen_string_literal: true
class GeoTranslations < ActiveRecord::Migration[5.0]
  def up
    Geo::City.create_translation_table! name: :string
    Geo::Adm3.create_translation_table! name: :string
    Geo::Adm4.create_translation_table! name: :string
    Geo::Adm5.create_translation_table! name: :string
    Geo::District.create_translation_table! name: :string
    Geo::Region.create_translation_table! name: :string
    Geo::Country.create_translation_table! name: :string
  end

  def down
    Geo::City.drop_translation_table!
    Geo::Adm3.drop_translation_table!
    Geo::Adm4.drop_translation_table!
    Geo::Adm5.drop_translation_table!
    Geo::District.drop_translation_table!
    Geo::Region.drop_translation_table!
    Geo::Country.drop_translation_table!
  end
end
