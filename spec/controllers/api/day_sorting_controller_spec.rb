describe Api::DaysSortingController do

  describe '#index' do
    login_user

    let(:trip) { FactoryGirl.create(:trip, users: [subject.current_user]) }

    it 'returns short information about days as json' do
      get 'index', trip_id: trip.id, format: :json

      json_days = JSON.parse(response.body)
      expect(json_days.count).to eq(trip.days.count)
      expect(json_days.first['index']).to eq(trip.days.first.index)
    end
  end

  describe '#create' do
    login_user

    let!(:trip) { FactoryGirl.create(:trip, :with_filled_days, users: [subject.current_user]) }

    it 'reorders days' do
      ids = trip.days.map { |day| day.id }
      temp = ids[0]
      ids[0] = ids[-1]
      ids[-1] = temp

      post 'create', trip_id: trip.id, day_ids: ids, format: :json

      days_after = trip.reload.days
      expect(days_after.first.id).to eq(ids.first)
      expect(days_after.last.id).to eq(ids.last)
    end

  end

end
