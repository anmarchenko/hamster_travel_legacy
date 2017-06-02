# frozen_string_literal: true
class AddAmounts < ActiveRecord::Migration[5.0]
  def change
    add_monetize :hotels, :amount
    add_monetize :transfers, :amount
    add_monetize :activities, :amount

    Travels::Hotel.reset_column_information
    Travels::Transfer.reset_column_information
    Travels::Activity.reset_column_information

    Travels::Hotel.all.each do |obj|
      obj.update_attributes(amount_cents: obj.price * 100) unless obj.price.blank?
    end
    Travels::Transfer.all.each do |obj|
      obj.update_attributes(amount_cents: obj.price * 100) unless obj.price.blank?
    end
    Travels::Activity.all.each do |obj|
      obj.update_attributes(amount_cents: obj.price * 100) unless obj.price.blank?
    end

    remove_column :hotels, :price
    remove_column :transfers, :price
    remove_column :activities, :price
  end
end
