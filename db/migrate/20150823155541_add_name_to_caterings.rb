# frozen_string_literal: true
class AddNameToCaterings < ActiveRecord::Migration[5.0]
  def change
    add_column :caterings, :name, :string
    Travels::Catering.reset_column_information
    Travels::Catering.all.each do |catering|
      catering.update_attributes(name: catering.city_text)
    end

    remove_column :caterings, :city_code
    remove_column :caterings, :city_text
  end
end
