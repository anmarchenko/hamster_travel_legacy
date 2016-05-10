class AddRatingToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :rating, :integer, default: 2

    ::Travels::Activity.all.each { |activity| activity.update_attributes(rating: 2) }
  end
end
