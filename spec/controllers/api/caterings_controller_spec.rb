describe Api::CateringsController do

  describe '#index' do
    let(:trip) { FactoryGirl.create(:trip, :with_caterings) }
    let(:empty_trip) { FactoryGirl.create(:trip) }

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        it 'returns trip caterings as JSON' do
          get 'index', trip_id: trip.id.to_s, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json.count).to eq(3)
          expect(json.first['city_code']).to eq(trip.caterings.first.city_code)
        end

        it 'returns one catering if there are nothing' do
          get 'index', trip_id: empty_trip.id.to_s, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json.count).to eq(1)
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'index', trip_id: 'no_trip', format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      it 'behaves the same' do
        get 'index', trip_id: trip.id.to_s, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json.count).to eq(3)
        expect(json.first['city_code']).to eq(trip.caterings.first.city_code)
      end
    end

  end

  describe '#create' do
    let(:trip_without_user) {FactoryGirl.create :trip}

    context 'when user is logged in' do
      login_user

      let(:trip) {FactoryGirl.create :trip, users: [subject.current_user]}
      let(:catering_params) { { caterings: {'1' => {id: Time.now.to_i, city_text: 'Paris'} } } }

      context 'and when there is trip' do

        context 'and when input params are valid' do
          it 'updates trip and heads 200' do
            post 'create', catering_params.merge(trip_id: trip.id), format: :json
            expect(response).to have_http_status 200
            updated_catering = trip.reload.caterings.first
            expect(updated_catering.city_text).to eq 'Paris'
          end
        end

        context 'and when user is not included in trip' do
          it 'heads 403' do
            post 'create', catering_params.merge(trip_id: trip_without_user.id), format: :json
            expect(response).to have_http_status 403
          end
        end

      end

      context 'and when there is no trip' do
        it 'heads 404' do
          post 'create', catering_params.merge(trip_id: 'no such trip'), format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create :trip}
      let(:catering_params) { { caterings: {'1' => {id: Time.now.to_i, city_text: 'Paris'} } } }
      it 'redirects to sign in' do
        post 'create', catering_params.merge(trip_id: trip.id), format: :json
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

end
