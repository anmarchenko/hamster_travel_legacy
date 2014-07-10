FactoryGirl.define do

  factory :trip, class: 'Travels::Trip' do
    sequence(:name){ |n| "Trip number #{n}" }
    start_date { Date.today - 7 }
    end_date {Date.today}

    association :author_user, factory: :user

    trait :with_filled_days do
      after :create do |trip|
        trip.days.each_with_index do |day, index|
          day.set(comment: "Day #{index}")
          day.set(add_price: rand(10000))
          2.times {day.transfers.create(build(:transfer, :with_destinations).attributes)}
          5.times { |index| day.activities.create(build(:activity, :with_data, order_index: index).attributes)}
          day.places.create(build(:place, :with_data).attributes)
          day.hotel = build(:hotel, :with_data).attributes
          day.save validate: false
        end
      end
    end

    trait :with_transfers do
      after :create do |trip|
        trip.days.each do |day|
          day.transfers.create(build(:transfer).attributes)
          day.transfers.create(build(:transfer, :with_destinations).attributes)
          day.transfers.create(build(:transfer, :flight).attributes)
        end
      end
    end

    trait :with_users do
      after :create do |trip|
        trip.users = create_list(:user, 2)
        trip.users << trip.author
        trip.save validate: false
      end
    end
  end

  factory :transfer, class: 'Travels::Transfer' do
    trait :with_destinations do
      city_from_code {Geo::City.all.first.geonames_code}
      city_from_text {Geo::City.all.first.name}

      city_to_code {Geo::City.all.last.geonames_code}
      city_to_text {Geo::City.all.last.name}

      price {rand(10000)}
    end

    trait :flight do
      city_from_code {Geo::City.all.first.geonames_code}
      city_from_text {Geo::City.all.first.name}

      city_to_code {Geo::City.all.last.geonames_code}
      city_to_text {Geo::City.all.last.name}

      price {rand(10000)}

      type {Travels::Transfer::Types::FLIGHT}

      code {'HH404'}
      company {'Hamster Airlines'}

      station_from {'HAM'}
      station_to {'FOO'}

      start_time (Date.today.beginning_of_day)
      end_time (Date.today.end_of_day)

      comment {'very long comment'}
    end
  end

  factory :activity, class: 'Travels::Activity' do
    trait :with_data do
      name {'Activity'}
      price {rand(10000)}
      comment {'Activity comment'}
      link_description {'Activity link description'}
      link_url {'http://cool.site'}
    end
  end

  factory :place, class: 'Travels::Place' do
    trait :with_data do
      city_code {Geo::City.all.first.geonames_code}
      city_text {Geo::City.all.first.name}
    end
  end

  factory :hotel, class: 'Travels::Hotel' do
    trait :with_data do
      name {'Hotel'}
      price {rand(10000)}
      comment {'Comment'}
      after :build do |hotel|
        hotel.links = [FactoryGirl.create(:external_link)]
      end
    end
  end

end
