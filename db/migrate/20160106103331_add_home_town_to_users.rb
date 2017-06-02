# frozen_string_literal: true
class AddHomeTownToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :home_town, index: true
  end
end
