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
    let(:trip){FactoryGirl.create(:trip)}

    it 'creates trip days on save' do
      expect(trip.days.count).to eq(8)
      expect(trip.days.first.date_when).to eq(trip.start_date)
      expect(trip.days.last.date_when).to eq(trip.end_date)
    end

    it 'recounts dates on update' do
      raise 'not implemented!!!!'
    end
  end

end