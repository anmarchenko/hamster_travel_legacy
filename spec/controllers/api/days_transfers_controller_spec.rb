describe Api::DaysTransfersController do
  describe '#index' do
    let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        it 'returns trip days as JSON' do
          get 'index', params: {trip_id: trip.id.to_s}, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)['days']
          expect(json.count).to eq(8)
          expect(json.first['date']).to eq(I18n.l(trip.start_date, format: '%d.%m.%Y %A'))
          expect(json.first['transfers'].count).to eq(trip.days.first.transfers.count)
          expect(json.first['activities']).to be_nil
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'index', params: {trip_id: 'no_trip'}, format: :json
          expect(response).to have_http_status 404
        end
      end

      context 'when trip is private' do
        let(:private_trip) { FactoryGirl.create(:trip, :with_filled_days, private: true) }

        it 'heads 403' do
          get 'index', params: {trip_id: private_trip.id.to_s}, format: :json
          expect(response).to have_http_status 403
        end
      end

      context 'when trip is private and current_user is one of participants' do
        let(:private_trip) { FactoryGirl.create(:trip, :with_filled_days, private: true, users: [subject.current_user]) }

        it 'heads 403' do
          get 'index', params: {trip_id: private_trip.id.to_s}, format: :json

          expect(response).to have_http_status 200

          json = JSON.parse(response.body)['days']
          expect(json.count).to eq(8)
          expect(json.first['date']).to eq(I18n.l(private_trip.start_date, format: '%d.%m.%Y %A'))
          expect(json.first['transfers'].count).to eq(private_trip.days.first.transfers.count)
          expect(json.first['activities']).to be_nil
        end
      end
    end

    context 'when no logged user' do
      it 'behaves the same' do
        get 'index', params: {trip_id: trip.id.to_s}, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)['days']
        expect(json.count).to eq(8)
        expect(json.first['date']).to eq(I18n.l(trip.start_date, format: '%d.%m.%Y %A'))
      end

      context 'when trip is private' do
        let(:private_trip) { FactoryGirl.create(:trip, :with_filled_days, private: true) }

        it 'heads 403' do
          get 'index', params: {trip_id: private_trip.id.to_s}, format: :json
          expect(response).to have_http_status 403
        end
      end
    end
  end

  describe '#create' do

    context 'when user is logged in' do
      login_user

      let(:day) { trip.days.first }
      let(:days_params) {
        {
            days:
                [
                    {
                        id: day.id.to_s,
                        places: [
                            {
                                city_id: Geo::City.all.first.id,
                                city_text: 'City',
                                missing_attr: 'AAAAA'
                            }
                        ],
                        transfers: [
                            {
                                city_from_id: Geo::City.all.to_a[0].id,
                                city_to_id: Geo::City.all.to_a[1].id,
                                links: [
                                    {id: nil, url: 'https://google.com', description: 'desc1'},
                                    {id: nil, url: 'https://rome2rio.com', description: 'desc2'}
                                ]
                            }
                        ],
                        hotel: {
                          name: 'new_hotel',
                          links: [
                              {id: nil, url: 'https://google2.com', description: 'desc1'}
                          ]
                        }
                    }
                ]
        }
      }

      context 'and when there is trip' do

        context 'and when input params are valid' do
          let(:trip) { FactoryGirl.create :trip, users: [subject.current_user] }

          it 'updates trip and heads 200' do
            post 'create', params: days_params.merge(trip_id: trip.id), format: :json
            expect(response).to have_http_status 200

            updated_day = trip.reload.days.first

            expect(updated_day.places.count).to eq(1)
            expect(updated_day.places.first.city_id).to eq(Geo::City.all.first.id)
            expect(updated_day.transfers.count).to eq(1)
            expect(updated_day.transfers.first.city_from_id).to eq(Geo::City.all.to_a[0].id)
            expect(updated_day.transfers.first.links.count).to eq(2)
            expect(updated_day.transfers.first.links.first.url).to eq('https://google.com')
            expect(updated_day.hotel.name).to eq('new_hotel')
            expect(updated_day.hotel.links.count).to eq(1)
            expect(updated_day.hotel.links.first.url).to eq('https://google2.com')
          end
        end

        context 'and when user is not included in trip' do
          let(:trip) { FactoryGirl.create :trip }

          it 'heads 403' do
            post 'create', params: days_params.merge(trip_id: trip.id), format: :json
            expect(response).to have_http_status 403
          end
        end

      end

      context 'and when there is no trip' do
        let(:trip) { FactoryGirl.create :trip }

        it 'heads 404' do
          post 'create', params: days_params.merge(trip_id: 'no such trip'), format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create :trip }
      let(:day) { trip.days.first }
      let(:days_params) {
        {
            days:
                [
                    {
                        id: day.id.to_s,
                        places: [
                            {
                                city_id: Geo::City.all.first.id,
                                city_text: 'City',
                                missing_attr: 'AAAAA'
                            }
                        ]
                    }
                ]
        }
      }
      it 'redirects to sign in' do
        post 'create', params: days_params.merge(trip_id: trip.id), format: :json
        expect(response).to have_http_status 401
      end
    end

  end


end