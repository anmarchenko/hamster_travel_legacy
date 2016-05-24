describe Api::V2::TransfersController do
  describe '#index' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:day) { trip.days.first }

    context 'when user is logged in' do
      login_user

      context 'and when there is trip' do
        it 'returns trip days as JSON' do
          get 'index', trip_id: trip.id.to_s, day_id: day.id, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['date']).to eq(I18n.l(trip.start_date, format: '%d.%m.%Y %A'))
          expect(json['transfers'].count).to eq(trip.days.first.transfers.count)
          expect(json['activities']).to be_nil
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'index', trip_id: 'no_trip', day_id: day.id, format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      it 'behaves the same' do
        get 'index', trip_id: trip.id.to_s, day_id: day.id, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json['date']).to eq(I18n.l(trip.start_date, format: '%d.%m.%Y %A'))
      end
    end
  end

  describe '#create' do

    context 'when user is logged in' do
      login_user

      let(:day_params) {
        {
            day: {
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
        }
      }

      context 'and when there is trip' do

        context 'and when input params are valid' do
          let(:trip) { FactoryGirl.create :trip, users: [subject.current_user] }
          let(:day) { trip.days.first }

          it 'updates trip and heads 200' do
            post 'create', day_params.merge(trip_id: trip.id, day_id: day.id), format: :json
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
          let(:day) { trip.days.first }

          it 'heads 403' do
            post 'create', day_params.merge(trip_id: trip.id, day_id: day.id), format: :json
            expect(response).to have_http_status 403
          end
        end

      end

      context 'and when there is no trip' do
        let(:trip) { FactoryGirl.create :trip }
        let(:day) { trip.days.first }

        it 'heads 404' do
          post 'create', day_params.merge(trip_id: 'no such trip', day_id: day.id), format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create :trip }
      let(:day) { trip.days.first }
      let(:days_params) {
        {
            places: [
                {
                    city_id: Geo::City.all.first.id,
                    city_text: 'City',
                    missing_attr: 'AAAAA'
                }
            ]
        }
      }
      it 'redirects to sign in' do
        post 'create', days_params.merge(trip_id: trip.id, day_id: day.id), format: :json
        expect(response).to redirect_to '/users/sign_in'
      end
    end

  end


end