# frozen_string_literal: true
class AddCurrencyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :currency, :string
    User.reset_column_information
    User.update_all(currency: 'RUB')
  end
end
