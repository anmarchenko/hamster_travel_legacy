# frozen_string_literal: true
class AddAddressToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :address, :string
  end
end
