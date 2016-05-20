describe Api::TripsController do
  describe '#show' do
    let(:trip) {FactoryGirl.create(:trip)}

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        it 'returns trip as JSON' do
          get 'show', id: trip.id.to_s, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['comment']).to eq(trip.comment)
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'show', id: 'no_trip', format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      it 'returns trip as JSON' do
        get 'show', id: trip.id.to_s, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json['comment']).to eq(trip.comment)
      end
    end
  end

  describe '#update' do
    let(:trip_without_user) {FactoryGirl.create :trip}

    context 'when user is logged in' do
      login_user

      let(:trip) {FactoryGirl.create :trip, users: [subject.current_user]}
      let(:trip_params) { { trip: {comment: 'new_comment', archived: true, budget_for: 2} } }

      context 'and when there is trip' do

        context 'and when input params are valid' do
          it 'updates trip and returns it' do
            put 'update', trip_params.merge(id: trip.id, format: :json)
            expect(response).to have_http_status 204
            updated_trip = trip.reload
            expect(updated_trip.comment).to eq 'new_comment'
            expect(updated_trip.archived).to eq false
          end
        end

        context 'and when user is not included in trip' do
          it 'heads 403' do
            put 'update', trip_params.merge(id: trip_without_user.id), format: :json
            expect(response).to have_http_status 403
          end
        end

      end

      context 'and when there is no trip' do
        it 'heads 404' do
          put 'update', trip_params.merge(id: 'blah', format: :json)
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create :trip}
      let(:trip_params) { { trip: {comment: 'new_comment', archived: true, budget_for: 2} } }

      it 'return unauthorized' do
        put 'update', trip_params.merge(id: trip.id, format: :json)
        expect(response).to have_http_status 401
      end
    end
  end

end