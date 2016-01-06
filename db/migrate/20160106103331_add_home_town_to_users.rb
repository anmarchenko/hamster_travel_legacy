class AddHomeTownToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :home_town, index: true
  end
end
