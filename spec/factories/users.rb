FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "person-#{n}@example.com" }
    sequence(:first_name) { |n| "FirstName-#{n}" }
    sequence(:last_name) { |n| "LastName-#{n}" }
    password '12345678'

    trait :with_home_town do
      home_town_code {Geo::City.where(status: Geo::City::Statuses::CAPITAL).first.try(:geonames_code)}
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
