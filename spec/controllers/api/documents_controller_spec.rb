describe Api::DocumentsController do
  describe '#index' do
    login_user

    context 'when logged user is included in trip' do
      let(:trip) { FactoryGirl.create(:trip, users: [subject.current_user]) }
      let!(:document) { FactoryGirl.create(:document, trip: trip) }

      it 'returns document jsons for trip' do
        get 'index', params: {trip_id: trip.id}
        json = JSON.parse(response.body)
        expect(json['documents'].count).to eq(1)
        doc = json['documents'].first
        expect(doc['id']).to eq(document.id)
        expect(doc['file_uid']).to be_nil
      end
    end

    context 'when logged user is not included in trip' do
      let(:trip) { FactoryGirl.create(:trip, :with_caterings) }
      let!(:document) { FactoryGirl.create(:document, trip: trip) }

      it 'returns documents json for trip' do
        get 'index', params: {trip_id: trip.id}
        expect(response).to redirect_to('/errors/no_access')
      end
    end
  end

  describe '#create' do
    login_user

    context 'when logged user is included in trip' do
      let(:trip) { FactoryGirl.create(:trip, users: [subject.current_user]) }

      let(:files) { {'0' => fixture_file_upload("#{::Rails.root}/spec/fixtures/files/cat.jpg", 'image/jpeg'),
                     '1' => fixture_file_upload("#{::Rails.root}/spec/fixtures/files/hamster.jpg", 'image/jpeg')} }

      it 'creates as many documents as there are uploaded files' do
        post 'create', params: { files: files, trip_id: trip.id }

        json = JSON.parse(response.body)
        expect(json['success']).to eq(true)

        docs = trip.reload.documents
        expect(docs.count).to eq(2)

        expect(docs.first.name).to eq('cat.jpg')
        expect(docs.first.mime_type).to eq('image/jpeg')
        expect(docs.first.file.remote_url =~ /\/system\/dragonfly\/test\/[A-Za-z0-9]{2}\/[A-Za-z0-9]{2}\/[A-Za-z0-9]{2}\/[A-Za-z0-9]{10}\/[A-Za-z0-9]{32}\.jpg/).not_to be_blank

        expect(docs.last.name).to eq('hamster.jpg')
        expect(docs.last.mime_type).to eq('image/jpeg')
        expect(docs.last.file.remote_url =~ /\/system\/dragonfly\/test\/[A-Za-z0-9]{2}\/[A-Za-z0-9]{2}\/[A-Za-z0-9]{2}\/[A-Za-z0-9]{10}\/[A-Za-z0-9]{32}\.jpg/).not_to be_blank
      end
    end
  end

  describe '#update' do
    login_user

    context 'when logged user is included in trip' do

    end
  end
end
