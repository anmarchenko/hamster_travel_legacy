describe Api::V2::ActivitiesController do

  describe '#index' do
    let!(:trip) { FactoryGirl.create(:trip, :with_filled_days) }

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        it 'returns trip days as JSON' do

          get 'index', trip_id: trip.id.to_s, day_id: trip.days.first.id.to_s, format: :json
          expect(response).to have_http_status 200
          day_json = JSON.parse(response.body)

          expect(day_json['date']).to eq(I18n.l(trip.start_date, format: '%d.%m.%Y %A'))
          expect(day_json['activities'].count).to eq(trip.days.first.activities.count)
          expect(day_json['links'].count).to eq(trip.days.first.links.count)
          expect(day_json['expenses'].count).to eq(trip.days.first.expenses.count)
          expect(day_json['comment']).to eq(trip.days.first.comment)
          expect(day_json['places'].count).to eq(trip.days.first.places.count)
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'index', trip_id: 'no_trip', day_id: 'whatever', format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      it 'behaves the same' do
        get 'index', trip_id: trip.id.to_s, day_id: trip.days.first.id.to_s, format: :json
        expect(response).to have_http_status 200
        day_json = JSON.parse(response.body)

        expect(day_json['date']).to eq(I18n.l(trip.start_date, format: '%d.%m.%Y %A'))
        expect(day_json['activities'].count).to eq(trip.days.first.activities.count)
        expect(day_json['links'].count).to eq(trip.days.first.links.count)
        expect(day_json['expenses'].count).to eq(trip.days.first.expenses.count)
        expect(day_json['comment']).to eq(trip.days.first.comment)
        expect(day_json['places'].count).to eq(trip.days.first.places.count)
      end
    end
  end

end