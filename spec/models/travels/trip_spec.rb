describe Travels::Trip do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:author_user_id) }

  it_should_behave_like 'a model with date interval', :trip, :start_date, :end_date

  it 'does not allow trips 30 days long' do
    trip = FactoryGirl.build(:trip, start_date: Date.today, end_date: Date.today + 30.days)
    expect(trip).not_to be_valid
  end

  it 'does not allow trips longer than 30 days' do
    trip = FactoryGirl.build(:trip, start_date: Date.today, end_date: Date.today + 35.days)
    expect(trip).not_to be_valid
  end

  describe '.where' do
    context 'when there are several trips' do
      before {FactoryGirl.create_list(:trip, 12, author_user_id: 'user_test_travels_trip')}

      it 'has default context with ordering by created_at' do
        trips = Travels::Trip.where(author_user_id: 'user_test_travels_trip').to_a
        expect(trips.count).to eq(12)
        trips.each_index do |i|
          next if trips[i+1].blank?
          expect(trips[i].created_at).to be > trips[i+1].created_at
        end
      end

      it 'paginates per 9 items by default' do
        trips = Travels::Trip.all.page(1).to_a
        expect(trips.count).to eq(9)
      end
    end
  end

  describe '#update_plan' do
    let(:trip){FactoryGirl.create(:trip, :with_filled_days)}

    it 'creates trip days on save' do
      expect(trip.days.count).to eq(8)
      expect(trip.days.first.date_when).to eq(trip.start_date)
      expect(trip.days.last.date_when).to eq(trip.end_date)
    end

    it 'recounts dates on update preserving other data' do
      trip.update_attributes(start_date: 14.days.ago, end_date: 7.days.ago)

      expect(trip.days.count).to eq(8)
      expect(trip.days.first.date_when).to eq(14.days.ago.to_date)
      expect(trip.days.last.date_when).to eq(7.days.ago.to_date)

      trip.days.each_with_index do |day, index|
        expect(day.comment).to eq("Day #{index}")
      end
    end

    it 'creates new days when necessary' do
      trip.update_attributes(start_date: 16.days.ago, end_date: 7.days.ago)

      expect(trip.days.count).to eq(10)
      expect(trip.days.first.date_when).to eq(16.days.ago.to_date)
      expect(trip.days.last.date_when).to eq(7.days.ago.to_date)
      expect(trip.days.last.comment).to be_nil
    end

    it 'deletes days when necessary' do
      trip.update_attributes(start_date: 12.days.ago, end_date: 7.days.ago)

      expect(trip.days.count).to eq(6)
      expect(trip.days.first.date_when).to eq(12.days.ago.to_date)
      expect(trip.days.last.date_when).to eq(7.days.ago.to_date)
      expect(trip.days.last.comment).to eq("Day 5")
    end
  end

  describe '#include_user' do
    let(:trip){FactoryGirl.create(:trip, :with_users)}
    let(:user){FactoryGirl.create(:user)}

    it 'includes some user' do
      expect(trip.include_user(trip.author)).to be true
    end

    it 'does not include new user' do
      expect(trip.include_user(user)).to be false
    end
  end

  describe '#last_non_empty_day_index' do
    let(:trip_empty){FactoryGirl.create(:trip)}
    let(:trip_full){FactoryGirl.create(:trip, :with_filled_days)}

    it 'returns -1 if all days are empty' do
      expect(trip_empty.last_non_empty_day_index).to eq(-1)
    end

    it 'returns last day index if all days are non-empty' do
      expect(trip_full.last_non_empty_day_index).to eq(7)
    end

    it 'returns last non-empty day index' do
      trip_empty.days[0].set(comment: 'comment')
      trip_empty.days[3].set(comment: 'comment')
      expect(trip_empty.last_non_empty_day_index).to eq(3)
    end
  end

  describe '#budget_sum' do
    context 'when empty trip' do
      let(:trip) {FactoryGirl.create(:trip)}

      it 'returns zero' do
        expect(trip.budget_sum).to eq(0)
      end
    end

    context 'when filled trip' do
      let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}

      it 'returns right budget' do
        hotel_price = trip.days.inject(0) { |sum, day| sum += day.hotel.price }
        days_add_price = trip.days.inject(0) { |sum, day| sum += day.add_price }
        transfers_price = trip.days.inject(0) { |s, day| s += day.transfers.inject(0) { |i_s, tr| i_s += tr.price} }
        activities_price = trip.days.inject(0) { |s, day| s += day.activities.inject(0) { |i_s, ac| i_s += ac.price} }

        expect(trip.budget_sum).to eq([hotel_price, days_add_price, transfers_price, activities_price].reduce(&:+))
      end
    end
  end

end