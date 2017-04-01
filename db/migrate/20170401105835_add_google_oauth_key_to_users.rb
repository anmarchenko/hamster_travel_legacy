class AddGoogleOauthKeyToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :google_oauth_key, :string
  end
end
