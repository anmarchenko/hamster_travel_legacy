describe Api::BudgetsController do
  describe '#show' do
    let(:trip) {FactoryGirl.create(:trip)}

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        it 'returns budget in JSON' do
          get 'show', id: trip.id.to_s, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['budget']).to eq(trip.budget_sum)
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
      it 'returns budget in JSON' do
        get 'show', id: trip.id.to_s, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json['budget']).to eq(trip.budget_sum)
      end
    end
  end
end