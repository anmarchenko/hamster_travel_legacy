class AddCountriesSearchIndexToTrips < ActiveRecord::Migration[5.0]
  def change
    add_column :trips, :countries_search_index, :string
  end
end
