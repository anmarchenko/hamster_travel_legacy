class RemoveDenormalizeColumns < ActiveRecord::Migration
  def change
    remove_column(:cities, :country_text)
    remove_column(:cities, :country_text_ru)
    remove_column(:cities, :country_text_en)
    remove_column(:cities, :region_text)
    remove_column(:cities, :region_text_ru)
    remove_column(:cities, :region_text_en)
    remove_column(:cities, :denormalized)
  end
end
