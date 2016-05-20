describe Api::BudgetsController do
  describe '#show' do
    let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        before do
          subject.current_user.update_attributes(currency: 'EUR')
        end

        it 'returns budget in JSON in user\'s currency' do
          get 'show', id: trip.id.to_s, format: :json
          expect(response).to have_http_status 200

          json = JSON.parse(response.body)
          expect(json['budget']['sum']).to eq(trip.budget_sum('EUR'))
          expect(json['budget']['transfers_hotel_budget']).to eq(trip.transfers_hotel_budget('EUR'))
          expect(json['budget']['activities_other_budget']).to eq(trip.activities_other_budget('EUR'))
          expect(json['budget']['catering_budget']).to eq(trip.catering_budget('EUR'))
          expect(json['budget']['budget_for']).to eq(trip.budget_for)
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
      it 'returns budget in JSON in default currency' do
        get 'show', id: trip.id.to_s, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json['budget']['sum']).to eq(trip.budget_sum('RUB'))
        expect(json['budget']['transfers_hotel_budget']).to eq(trip.transfers_hotel_budget('RUB'))
        expect(json['budget']['activities_other_budget']).to eq(trip.activities_other_budget('RUB'))
        expect(json['budget']['catering_budget']).to eq(trip.catering_budget('RUB'))
        expect(json['budget']['budget_for']).to eq(trip.budget_for)
      end
    end
  end

  describe '#create' do
  end
end