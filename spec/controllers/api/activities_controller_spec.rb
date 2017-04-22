# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::ActivitiesController do
  let(:user) { FactoryGirl.create(:user) }

  describe '#index' do
    let!(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:days) { Trips::Days.list(trip) }
    let(:first_day) { days.first }
    let(:first_day_activities) { Trips::Activities.list(first_day) }
    let(:first_day_links) { Trips::Links.list_day(first_day) }
    let(:first_day_expenses) { Trips::Expenses.list(first_day) }
    let(:first_day_places) { Trips::Places.list(first_day) }

    context 'when user is logged in' do
      before { login_user(user) }

      context 'and when there is trip' do
        it 'returns trip days as JSON' do
          get 'index', params: {
            trip_id: trip.id.to_s,
            day_id: trip.days.ordered.first.id.to_s
          }, format: :json
          expect(response).to have_http_status 200
          day_json = JSON.parse(response.body)

          expect(day_json['date']).to eq(
            I18n.l(trip.start_date, format: '%d.%m.%Y %A')
          )
          expect(day_json['activities'].count).to eq(
            first_day_activities.count
          )
          expect(day_json['links'].count).to eq(
            first_day_links.count
          )
          expect(day_json['expenses'].count).to eq(
            first_day_expenses.count
          )
          expect(day_json['comment']).to eq(first_day.comment)
          expect(day_json['places'].count).to eq(
            first_day_places.count
          )
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'index', params: {
            trip_id: 'no_trip',
            day_id: 'whatever'
          }, format: :json
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      it 'behaves the same' do
        get 'index', params: {
          trip_id: trip.id.to_s,
          day_id: trip.days.ordered.first.id.to_s
        }, format: :json
        expect(response).to have_http_status 200
        day_json = JSON.parse(response.body)

        expect(day_json['date']).to eq(
          I18n.l(trip.start_date, format: '%d.%m.%Y %A')
        )
        expect(day_json['activities'].count).to eq(
          first_day_activities.count
        )
        expect(day_json['links'].count).to eq(
          first_day_links.count
        )
        expect(day_json['expenses'].count).to eq(
          first_day_expenses.count
        )
        expect(day_json['comment']).to eq(first_day.comment)
        expect(day_json['places'].count).to eq(
          first_day_places.count
        )
      end
    end
  end

  describe '#create' do
    let(:trip_without_user) { FactoryGirl.create :trip }

    context 'when user is logged in' do
      before { login_user(user) }
      let(:city) { FactoryGirl.create(:city) }
      let(:trip) { FactoryGirl.create :trip, users: [subject.current_user] }

      let(:days) { Trips::Days.list(trip) }
      let(:day) { days.first }

      let(:day_params) do
        {
          day:
              {
                id: day.id.to_s,
                comment: 'new_day_comment',
                places: [
                  {
                    city_id: city.id,
                    city_text: 'City',
                    missing_attr: 'AAAAA'
                  }
                ],
                activities: [
                  {
                    name: 'new_activity',
                    address: '10553 Berlin Randomstr. 12',
                    working_hours: '12 - 18'
                  }
                ]
              }
        }
      end

      context 'and when there is trip' do
        context 'and when input params are valid' do
          it 'updates trip and heads 200' do
            post 'create', params: day_params.merge(
              trip_id: trip.id, day_id: day.id
            ), format: :json
            expect(response).to have_http_status 200
            updated_day = day.reload
            expect(updated_day.comment).to eq 'new_day_comment'
            places = Trips::Places.list(updated_day)
            expect(places.count).to eq(1)
            expect(places.first.city_id).to eq(city.id)
            activities = Trips::Activities.list(updated_day)
            expect(activities.count).to eq(1)
            expect(activities.first.name).to eq('new_activity')
            expect(activities.first.address).to eq(
              '10553 Berlin Randomstr. 12'
            )
            expect(activities.first.working_hours).to eq('12 - 18')
          end
        end

        context 'and when user is not included in trip' do
          it 'heads 403' do
            post 'create', params: day_params.merge(
              trip_id: trip_without_user.id,
              day_id: trip_without_user.days.ordered.first.id
            ), format: :json
            expect(response).to have_http_status 403
          end
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          post 'create', params: day_params.merge(
            trip_id: 'no such trip',
            day_id: day.id
          ), format: :json
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create :trip }
      let(:days) { Trips::Days.list(trip) }
      let(:day) { days.first }
      let(:day_params) do
        {
          day:
              {
                id: day.id.to_s,
                comment: 'new_day_comment',
                places: [
                  {
                    city_id: 43_432,
                    city_text: 'City',
                    missing_attr: 'AAAAA'
                  }
                ]
              }
        }
      end
      it 'redirects to sign in' do
        post 'create', params: day_params.merge(
          trip_id: trip.id,
          day_id: day.id
        ), format: :json
        expect(response).to have_http_status 401
      end
    end
  end
end
