# frozen_string_literal: true
class RemoveMongoIdFromTransfers < ActiveRecord::Migration
  def change
    remove_column :transfers, :mongo_id
    remove_column :transfers, :type_icon
    remove_column :external_links, :mongo_id
    remove_column :users, :mongo_id
    remove_column :adm3s, :mongo_id
    remove_column :adm4s, :mongo_id
    remove_column :adm5s, :mongo_id
    remove_column :cities, :mongo_id
    remove_column :countries, :mongo_id
    remove_column :districts, :mongo_id
    remove_column :regions, :mongo_id
    remove_column :activities, :mongo_id
    remove_column :days, :mongo_id
    remove_column :expenses, :mongo_id
    remove_column :hotels, :mongo_id
    remove_column :places, :mongo_id
    remove_column :trips, :mongo_id
  end
end
