# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string
#  encrypted_password     :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  first_name             :string
#  last_name              :string
#  home_town_code         :string
#  home_town_text         :string
#  locale                 :string
#  image_uid              :string
#  mongo_id               :string
#  created_at             :datetime
#  updated_at             :datetime
#  currency               :string
#

FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "person-#{n}@example.com" }
    sequence(:first_name) { |n| "FirstName-#{n}" }
    sequence(:last_name) { |n| "LastName-#{n}" }
    password '12345678'

    trait :with_home_town do
      home_town_id {Geo::City.where(status: Geo::City::Statuses::CAPITAL).first.try(:id)}
      home_town_text {Geo::City.where(status: Geo::City::Statuses::CAPITAL).first.try(:name)}
    end

    trait :with_trips do
      after :create do |user|
        FactoryGirl.create_list(:trip, 4, author_user_id: user.id, users: [user])
        FactoryGirl.create(:trip, users: [user])
      end
    end
  end

end
