describe Api::ParticipantsController do

  describe '#index' do
    let(:trip) {FactoryGirl.create(:trip, :with_users)}

    it 'returns list of participants' do
      get 'index', id: trip.id
      expect(response).to have_http_status 200
      json = JSON.parse(response.body)

      expect(json.count).to eq(3)
    end
  end
end