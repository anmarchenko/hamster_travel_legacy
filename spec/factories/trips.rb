FactoryGirl.define do

  factory :trip, class: 'Travels::Trip' do
    sequence(:name){ |n| "Trip number #{n}" }
    start_date { 7.days.ago }
    end_date {Date.today}

    author_user_id 'non_existing_user'
  end

end
