describe Api::DaysController do

  describe '#index' do
    let(:trip) {FactoryGirl.create(:trip)}

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        it 'returns trip days as JSON' do
          get 'index', trip_id: trip.id.to_s, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json.count).to eq(8)
          expect(json.first['date']).to eq(I18n.l(trip.start_date, format: '%d.%m.%Y %A'))
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
        expect(json.count).to eq(8)
        expect(json.first['date']).to eq(I18n.l(trip.start_date, format: '%d.%m.%Y %A'))
      end
    end
  end

  describe '#create' do
    let(:trip_without_user) {FactoryGirl.create :trip}

    context 'when user is logged in' do
      login_user

      let(:trip) {FactoryGirl.create :trip, users: [subject.current_user]}
      let(:day) {trip.days.first}
      let(:days_params) { { days: {'1' => {id: day.id.to_s, comment: 'new_day_comment'} } } }

      context 'and when there is trip' do

        context 'and when input params are valid' do
          it 'updates trip and heads 200' do
            post 'create', days_params.merge(trip_id: trip.id), format: :json
            expect(response).to have_http_status 200
            updated_day = trip.reload.days.first
            expect(updated_day.comment).to eq 'new_day_comment'
          end
        end

        context 'and when user is not included in trip' do
          it 'heads 403' do
            post 'create', days_params.merge(trip_id: trip_without_user.id), format: :json
            expect(response).to have_http_status 403
          end
        end

      end

      context 'and when there is no trip' do
        it 'heads 404' do
          post 'create', days_params.merge(trip_id: 'no such trip'), format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create :trip}
      let(:day) {trip.days.first}
      let(:days_params) { { days: {'1' => {id: day.id.to_s, comment: 'new_day_comment'} } } }
      it 'redirects to sign in' do
        post 'create', days_params.merge(trip_id: trip.id), format: :json
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#show' do
    let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}
    let(:day) {trip.days.first}

    context 'when user is logged in' do
      login_user

      context 'and when there is day' do
        it 'returns day as json' do
          get 'show', trip_id: trip.id.to_s, id: day.id, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['comment']).to eq(day.comment)
          expect(json['transfers'].count).to eq(day.transfers.count)
        end
      end

      context 'and when there is no day' do
        it 'returns 404' do
          get 'show', trip_id: trip.id.to_s, id: 'hmm', format: :json
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      it 'returns day as json' do
        get 'show', trip_id: trip.id.to_s, id: day.id, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json['comment']).to eq(day.comment)
        expect(json['transfers'].count).to eq(day.transfers.count)
      end
    end
  end

  describe '#update' do
    let(:trip_without_user) {FactoryGirl.create :trip}

    context 'when user is logged in' do
      login_user

      let(:trip) {FactoryGirl.create :trip, users: [subject.current_user]}
      let(:day) {trip.days.first}
      let(:days_params) { { days: {id: day.id.to_s, comment: 'new_day_comment'} } }

      context 'and when there is trip' do

        context 'and when input params are valid' do
          it 'updates trip and heads 200' do
            put 'update', days_params.merge(trip_id: trip.id, id: day.id), format: :json
            expect(response).to have_http_status 200
            updated_day = trip.reload.days.first
            expect(updated_day.comment).to eq 'new_day_comment'
          end
        end

        context 'and when user is not included in trip' do
          it 'heads 403' do
            put 'update', days_params.merge(trip_id: trip_without_user.id, id: day.id), format: :json
            expect(response).to have_http_status 403
          end
        end

      end

      context 'and when there is no trip' do
        it 'heads 404' do
          put 'update', days_params.merge(trip_id: 'no such trip', id: day.id), format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create :trip}
      let(:day) {trip.days.first}
      let(:days_params) { { days: {id: day.id.to_s, comment: 'new_day_comment'} } }
      it 'redirects to sign in' do
        put 'update', days_params.merge(trip_id: trip.id, id: day.id), format: :json
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end


end