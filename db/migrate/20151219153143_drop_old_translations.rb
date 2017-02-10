# frozen_string_literal: true
class DropOldTranslations < ActiveRecord::Migration
  def change
    remove_column(:adm3s, :name)
    remove_column(:adm3s, :name_ru)
    remove_column(:adm3s, :name_en)
    remove_column(:adm4s, :name)
    remove_column(:adm4s, :name_ru)
    remove_column(:adm4s, :name_en)
    remove_column(:adm5s, :name)
    remove_column(:adm5s, :name_ru)
    remove_column(:adm5s, :name_en)
    remove_column(:cities, :name)
    remove_column(:cities, :name_ru)
    remove_column(:cities, :name_en)
    remove_column(:countries, :name)
    remove_column(:countries, :name_ru)
    remove_column(:countries, :name_en)
    remove_column(:regions, :name)
    remove_column(:regions, :name_ru)
    remove_column(:regions, :name_en)
    remove_column(:districts, :name)
    remove_column(:districts, :name_ru)
    remove_column(:districts, :name_en)
  end
end
