FactoryGirl.define do

  factory :trip, class: 'Travels::Trip' do
    sequence(:name){ |n| "Trip number #{n}" }
    start_date { 7.days.ago }
    end_date {Date.today}

    association :author_user, factory: :user

    trait :with_commented_days do
      after :create do |trip|
        trip.days.each_with_index { |day, index| day.set(comment: "Day #{index}") }
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

end
