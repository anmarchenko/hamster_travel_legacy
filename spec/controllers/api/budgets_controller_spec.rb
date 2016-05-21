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

  describe '#update' do

    context 'when user is logged in' do
      login_user

      context 'and when user is a participant' do
        let(:trip) {FactoryGirl.create(:trip, :with_filled_days, users: [subject.current_user])}

        it 'updates budget_for field and returns ok status' do
          put 'update', {id: trip.id, budget_for: 42}, format: :json
          json = JSON.parse(response.body)
          expect(json['res']).to eq(true)

          expect(trip.reload.budget_for).to eq(42)
        end
      end

      context 'and when user is not a participant' do
        let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}

        it 'returns not authorized error and does not update budget_for field' do
          put 'update', {id: trip.id, budget_for: 42}, format: :json

          expect(response).to have_http_status 403

          expect(trip.reload.budget_for).to eq(1)
        end
      end


    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}

      it 'redirects to sign in' do
        put 'update', {id: trip.id, budget_for: 42}, format: :json
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end