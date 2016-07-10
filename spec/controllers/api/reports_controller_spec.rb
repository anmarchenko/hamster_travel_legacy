describe Api::ReportsController do
  describe '#show' do
    let(:trip) {FactoryGirl.create(:trip)}

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        it 'returns trip report (comment)' do
          get 'show', params: {id: trip.id.to_s}, format: :json
          expect(response).to have_http_status 200

          json = JSON.parse(response.body)
          expect(json['report']).to eq(trip.report)
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
      it 'returns trip report (comment)' do
        get 'show', params: {id: trip.id.to_s}, format: :json
        expect(response).to have_http_status 200

        json = JSON.parse(response.body)
        expect(json['report']).to eq(trip.comment)
      end
    end
  end

  describe '#update' do

    context 'when user is logged in' do
      login_user

      context 'and when user is a participant' do
        let(:trip) {FactoryGirl.create(:trip, :with_filled_days, users: [subject.current_user])}

        it 'updates budget_for field and returns ok status' do
          put 'update', params: {id: trip.id, report: 'new_report'}, format: :json
          json = JSON.parse(response.body)
          expect(json['res']).to eq(true)

          expect(trip.reload.report).to eq('new_report')
        end
      end

      context 'and when user is not a participant' do
        let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}

        it 'returns not authorized error and does not update budget_for field' do
          put 'update', params: {id: trip.id, report: 'new_report'}, format: :json

          expect(response).to have_http_status 403

          expect(trip.reload.report).not_to eq('new_report')
        end
      end


    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}

      it 'redirects to sign in' do
        put 'update', params: {id: trip.id, report: 'new_report'}, format: :json
        expect(response).to have_http_status 401
      end
    end
  end
end