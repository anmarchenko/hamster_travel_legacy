RSpec.describe Api::TripsController do
  describe '#index' do
    before { FactoryGirl.create_list(:trip, 12) }
    before { FactoryGirl.create_list(:trip, 2, status_code: Travels::Trip::StatusCodes::FINISHED) }

    context 'when user is logged in' do
      login_user

      before { FactoryGirl.create_list(:trip, 2, user_ids: [subject.current_user.id]) }
      before { FactoryGirl.create_list(:trip, 1, :no_dates, user_ids: [subject.current_user.id]) }

      before { FactoryGirl.create_list(:trip, 1, user_ids: [subject.current_user.id],
                                       status_code: Travels::Trip::StatusCodes::FINISHED) }
      before { FactoryGirl.create_list(:trip, 4, user_ids: [subject.current_user.id],
                                       status_code: Travels::Trip::StatusCodes::PLANNED) }

      before { FactoryGirl.create_list(:trip, 1, user_ids: [subject.current_user.id], name: 'tripppp',
                                       private: true, status_code: Travels::Trip::StatusCodes::FINISHED) }

      it 'searches visible by user trips' do
        get 'index', params: { term: 'trippp' }
        json = JSON.parse(response.body)
        expect(json.count).to eq(1)
      end
    end

    context 'when no logged user' do
      it 'searches public trips' do
        get 'index', params: { term: 'trip' }
        json = JSON.parse(response.body)
        expect(json.count).to eq(2)
      end
    end
  end
end