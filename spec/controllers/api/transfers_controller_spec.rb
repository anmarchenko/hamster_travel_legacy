# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::TransfersController do
  let(:user) { FactoryGirl.create(:user) }
  let(:city_from) { FactoryGirl.create(:city) }
  let(:city_to) { FactoryGirl.create(:city) }

  describe '#index' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:days) { Trips::Days.list(trip) }
    let(:day) { days.first }
    let(:transfers) { Trips::Transfers.list(day) }

    context 'when user is logged in' do
      before { login_user(user) }

      context 'and when there is trip' do
        it 'returns trip days as JSON' do
          get 'index', params: {
            trip_id: trip.id.to_s, day_id: day.id
          }, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['date']).to eq(
            I18n.l(trip.start_date, format: '%d.%m.%Y %A')
          )
          expect(json['transfers'].count).to eq(
            transfers.count
          )
          expect(json['activities']).to be_nil
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'index', params: {
            trip_id: 'no_trip', day_id: day.id
          }, format: :json
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      it 'behaves the same' do
        get 'index', params: {
          trip_id: trip.id.to_s, day_id: day.id
        }, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json['date']).to eq(
          I18n.l(trip.start_date, format: '%d.%m.%Y %A')
        )
      end
    end
  end

  describe '#create' do
    context 'when user is logged in' do
      before { login_user(user) }

      let(:day_params) do
        {
          day: {
            places: [
              {
                city_id: city_to.id,
                city_text: 'City',
                missing_attr: 'AAAAA'
              }
            ],
            transfers: [
              {
                city_from_id: city_from.id,
                city_to_id: city_to.id,
                links: [
                  { id: nil, url: 'https://google.com', description: 'desc1' },
                  { id: nil, url: 'https://rome2rio.com', description: 'desc2' }
                ]
              }
            ],
            hotel: {
              name: 'new_hotel',
              links: [
                { id: nil, url: 'https://google2.com', description: 'desc1' }
              ]
            }
          }
        }
      end

      context 'and when there is trip' do
        context 'and when input params are valid' do
          let(:trip) { FactoryGirl.create :trip, users: [subject.current_user] }
          let(:days) { Trips::Days.list(trip) }
          let(:day) { days.first }

          it 'updates trip and heads 200' do
            post 'create', params: day_params.merge(
              trip_id: trip.id, day_id: day.id
            ), format: :json
            expect(response).to have_http_status 200

            updated_day = day.reload

            places = Trips::Places.list(updated_day)
            expect(places.count).to eq(1)
            expect(places.first.city_id).to eq(city_to.id)
            transfers = Trips::Transfers.list(updated_day)
            expect(transfers.count).to eq(1)
            expect(transfers.first.city_from_id).to eq(city_from.id)
            transfer_links = Trips::Links.list_transfer(transfers.first)
            expect(transfer_links.count).to eq(2)
            expect(transfer_links.map(&:url).sort).to eq(
              ['https://google.com', 'https://rome2rio.com']
            )
            hotel = Trips::Hotels.by_day(updated_day)
            expect(hotel.name).to eq('new_hotel')
            hotel_links = Trips::Links.list_hotel(hotel)
            expect(hotel_links.count).to eq(1)
            expect(hotel_links.first.url).to eq(
              'https://google2.com'
            )
          end
        end

        context 'and when user is not included in trip' do
          let(:trip) { FactoryGirl.create :trip }
          let(:day) { trip.days.ordered.first }

          it 'heads 403' do
            post 'create', params: day_params.merge(
              trip_id: trip.id, day_id: day.id
            ), format: :json
            expect(response).to have_http_status 403
          end
        end
      end

      context 'and when there is no trip' do
        let(:trip) { FactoryGirl.create :trip }
        let(:day) { trip.days.ordered.first }

        it 'heads 404' do
          post 'create', params: day_params.merge(
            trip_id: 'no such trip', day_id: day.id
          ), format: :json
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create :trip }
      let(:day) { trip.days.ordered.first }
      let(:days_params) do
        {
          places: [
            {
              city_id: city_to.id,
              city_text: 'City',
              missing_attr: 'AAAAA'
            }
          ]
        }
      end
      it 'redirects to sign in' do
        post 'create', params: days_params.merge(
          trip_id: trip.id, day_id: day.id
        ), format: :json
        expect(response).to have_http_status 401
      end
    end
  end

  describe '#previous_place' do
    context 'when trip is full' do
      let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
      let(:days) { Trips::Days.list(trip) }
      let(:day) { days.to_a[2] }
      let(:prev_day) { days.to_a[1] }
      let(:prev_place) { Trips::Places.list(prev_day).last }
      let(:first_day) { days.first }

      it 'returns last place from previous day' do
        get 'previous_place', params: { trip_id: trip.id, day_id: day.id }

        json = JSON.parse(response.body)
        expect(json['place']).not_to be_blank
        expect(json['place']['id']).to eq(prev_place.id.to_s)
        expect(json['place']['city_id']).to eq(prev_place.city_id)
      end

      it 'returns 404 if asked for the first day' do
        get 'previous_place', params: { trip_id: trip.id, day_id: first_day.id }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe '#previous_hotel' do
    context 'when trip is full' do
      let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
      let(:days) { Trips::Days.list(trip) }
      let(:day) { days.to_a[2] }
      let(:prev_day) { days.to_a[1] }
      let(:prev_hotel) { Trips::Hotels.by_day(prev_day) }
      let(:first_day) { days.first }

      it 'returns hotel from previous day' do
        get 'previous_hotel', params: { trip_id: trip.id, day_id: day.id }

        json = JSON.parse(response.body)
        expect(json['hotel']).not_to be_blank
        expect(json['hotel']['id']).to eq(prev_hotel.id.to_s)
        expect(json['hotel']['name']).to eq(prev_hotel.name)
      end

      it 'returns 404 if asked for the first day' do
        get 'previous_hotel', params: { trip_id: trip.id, day_id: first_day.id }

        expect(response).to have_http_status(404)
      end
    end
  end
end
