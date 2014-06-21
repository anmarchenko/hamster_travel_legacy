FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "person-#{n}@example.com" }
    sequence(:first_name) { |n| "FirstName-#{n}" }
    sequence(:last_name) { |n| "LastName-#{n}" }
    password '12345678'

    factory :user_with_home_town do
      home_town_code {Geo::City.where(status: Geo::City::Statuses::CAPITAL).first.try(:geonames_code)}
      home_town_text {Geo::City.where(status: Geo::City::Statuses::CAPITAL).first.try(:name)}
    end
  end

end
