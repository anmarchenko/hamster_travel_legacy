class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email
      t.string :encrypted_password

      ## Recoverable
      t.string :reset_password_token
      t.timestamp :reset_password_sent_at

      ## Rememberable
      t.timestamp :remember_created_at

      ## Trackable
      t.integer :sign_in_count
      t.timestamp :current_sign_in_at
      t.timestamp :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      # Additional core fields
      t.string :first_name
      t.string :last_name

      # User settings

      # home town
      # geonames_code
      t.string :home_town_code
      # localized text
      t.string :home_town_text
      t.string :locale
      t.string :image_uid

      t.string :mongo_id

      t.timestamp :created_at
      t.timestamp :updated_at
    end
  end
end
