RSpec.describe Finders::Trips do
  describe '.search' do
    let(:user) { FactoryGirl.create(:user) }

    before { FactoryGirl.create_list(:trip, 2, user_ids: [user.id]) }
    before { FactoryGirl.create_list(:trip, 1, :no_dates, user_ids: [user.id]) }

    before { FactoryGirl.create_list(:trip, 1, user_ids: [user.id],
                                     status_code: Travels::Trip::StatusCodes::FINISHED) }
    before { FactoryGirl.create_list(:trip, 4, user_ids: [user.id],
                                     status_code: Travels::Trip::StatusCodes::PLANNED) }

    before { FactoryGirl.create_list(:trip, 12) }
    before { FactoryGirl.create_list(:trip, 2, status_code: Travels::Trip::StatusCodes::FINISHED) }

    before { FactoryGirl.create_list(:trip, 1, user_ids: [user.id], name: 'tripppppppp',
                                     private: true, status_code: Travels::Trip::StatusCodes::FINISHED) }

    it 'searches for public trips by name' do
      res = Finders::Trips.search('trip')
      expect(res.count).to eq(7) # all public trips
    end

    it 'returns empty result if nothing is found' do
      res = Finders::Trips.search('tripsssss')
      expect(res.count).to eq(0)
      res = Finders::Trips.search('trippppp')
      expect(res.count).to eq(0)
    end

    it 'searches for trips visible by user' do
      res = Finders::Trips.search('trippppp', user)
      expect(res.count).to eq(1)
      res = Finders::Trips.search('trip', user)
      expect(res.count).to eq(11)
    end
  end
end
