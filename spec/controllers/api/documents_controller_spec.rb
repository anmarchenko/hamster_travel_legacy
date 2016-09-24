describe Api::DocumentsController do

  describe '#index' do
    login_user

    let(:trip) { FactoryGirl.create(:trip, :with_caterings, users: [subject.current_user]) }
    let!(:document) { FactoryGirl.create(:document, trip: trip) }

    it 'returns document jsons for trip' do
      get 'index', params: { trip_id: trip.id }
      json = JSON.parse(response.body)
      expect(json['documents'].count).to eq(1)
      doc = json['documents'].first
      expect(doc['id']).to eq(document.id)
      expect(doc['file_uid']).to be_nil
    end

    context 'when user is not included in trip' do
      # TODO
    end
  end
end
