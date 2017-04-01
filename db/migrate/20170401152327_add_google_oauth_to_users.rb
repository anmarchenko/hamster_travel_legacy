class AddGoogleOauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :google_oauth_token, :string
    add_column :users, :google_oauth_uid, :string
    add_column :users, :google_oauth_expires_at, :datetime
    remove_column :users, :google_oauth_key
  end
end
