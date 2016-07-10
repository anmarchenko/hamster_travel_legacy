describe Api::CateringsController do

  describe '#index' do
    let(:trip) { FactoryGirl.create(:trip, :with_caterings) }
    let(:empty_trip) { FactoryGirl.create(:trip) }

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        it 'returns trip caterings as JSON' do
          get 'show', params: {id: trip.id.to_s}, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['caterings'].count).to eq(3)
          expect(json['caterings'].first['name']).to eq(trip.caterings.first.name)
        end

        it 'returns one catering if there are nothing' do
          get 'show', params: {id: empty_trip.id.to_s}, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)

          expect(json['caterings'].count).to eq(1)
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'show', params: {id: 'no_trip'}, format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      it 'behaves the same' do
        get 'show', params: {id: trip.id.to_s}, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json['caterings'].count).to eq(3)
        expect(json['caterings'].first['name']).to eq(trip.caterings.first.name)
      end
    end

  end

  describe '#create' do
    let(:trip_without_user) { FactoryGirl.create :trip }

    context 'when user is logged in' do
      login_user

      let(:trip) { FactoryGirl.create :trip, users: [subject.current_user] }
      let(:catering_params) { {trip: {caterings: [{id: Time.now.to_i, name: 'Paris', description: 'Desc'}]}} }

      context 'and when there is trip' do

        context 'and when input params are valid' do
          it 'updates trip and heads 200' do
            put 'update', params: catering_params.merge(id: trip.id), format: :json
            expect(response).to have_http_status 200
            updated_catering = trip.reload.caterings.first
            expect(updated_catering.name).to eq 'Paris'
            expect(updated_catering.description).to eq 'Desc'
          end
        end

        context 'and when user is not included in trip' do
          it 'heads 403' do
            put 'update', params: catering_params.merge(id: trip_without_user.id), format: :json
            expect(response).to have_http_status 403
          end
        end

      end

      context 'and when there is no trip' do
        it 'heads 404' do
          put 'update', params: catering_params.merge(id: 'no such trip'), format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create :trip }
      let(:catering_params) { {trip: {caterings: [{id: Time.now.to_i, city_text: 'Paris'}]}} }
      it 'redirects to sign in' do
        put 'update', params: catering_params.merge(id: trip.id), format: :json
        expect(response).to have_http_status 401
      end
    end
  end

end
