# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::DaysTransfersController do
  let(:user) { FactoryGirl.create(:user) }

  describe '#index' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:days) { Trips::Days.list(trip) }

    let(:first_day) { days.first }
    let(:first_day_transfers) { Trips::Transfers.list(first_day) }

    context 'when user is logged in' do
      before { login_user(user) }

      context 'and when there is trip' do
        it 'returns trip days as JSON' do
          get 'index', params: { trip_id: trip.id.to_s }, format: :json
          expect(response).to have_http_status 200
          json = JSON.parse(response.body)['days']
          expect(json.count).to eq(3)
          expect(json.first['date']).to eq(
            I18n.l(trip.start_date, format: '%d.%m.%Y %A')
          )
          expect(json.first['transfers'].count).to eq(
            first_day_transfers.count
          )
          expect(json.first['activities']).to be_nil
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'index', params: { trip_id: 'no_trip' }, format: :json
          expect(response).to have_http_status 404
        end
      end

      context 'when trip is private' do
        let(:private_trip) do
          FactoryGirl.create(:trip, :with_filled_days, private: true)
        end

        it 'heads 403' do
          get 'index', params: { trip_id: private_trip.id.to_s }, format: :json
          expect(response).to have_http_status 403
        end
      end

      context 'when trip is private and current_user is one of participants' do
        let(:private_trip) do
          FactoryGirl.create(
            :trip,
            :with_filled_days,
            private: true,
            users: [subject.current_user]
          )
        end
        let(:days) { Trips::Days.list(private_trip) }

        let(:first_day) { days.first }
        let(:first_day_transfers) { Trips::Transfers.list(first_day) }

        it 'heads 403' do
          get 'index', params: { trip_id: private_trip.id.to_s }, format: :json

          expect(response).to have_http_status 200

          json = JSON.parse(response.body)['days']
          expect(json.count).to eq(3)
          expect(json.first['date']).to eq(
            I18n.l(private_trip.start_date, format: '%d.%m.%Y %A')
          )
          expect(json.first['transfers'].count).to eq(
            first_day_transfers.count
          )
          expect(json.first['activities']).to be_nil
        end
      end
    end

    context 'when no logged user' do
      it 'behaves the same' do
        get 'index', params: { trip_id: trip.id.to_s }, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)['days']
        expect(json.count).to eq(3)
        expect(json.first['date']).to eq(
          I18n.l(trip.start_date, format: '%d.%m.%Y %A')
        )
      end

      context 'when trip is private' do
        let(:private_trip) do
          FactoryGirl.create(:trip, :with_filled_days, private: true)
        end

        it 'heads 403' do
          get 'index', params: { trip_id: private_trip.id.to_s }, format: :json
          expect(response).to have_http_status 403
        end
      end
    end
  end
end
