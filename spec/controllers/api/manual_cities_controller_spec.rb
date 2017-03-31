# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::ManualCitiesController do
  let(:user) { FactoryGirl.create(:user) }
  describe '#index' do
    before { login_user(user) }

    context 'when user is trying to acess his own data' do
      context 'when no manual cities' do
        it 'returns empty list' do
          get 'index', params: { user_id: subject.current_user.id }

          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['manual_cities'].count).to eq(0)
        end
      end

      context 'when there are manual cities' do
        let(:city1) { FactoryGirl.create(:city) }
        let(:city2) { FactoryGirl.create(:city) }
        let(:city_ids) { [city1.id, city2.id].sort }
        before do
          user.manual_cities << city1
          user.manual_cities << city2
          user.save
        end

        it 'returns list of the cities in JSON' do
          get 'index', params: { user_id: user.id }

          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['manual_cities'].count).to eq(2)
          expect(
            [
              json['manual_cities'].first['id'],
              json['manual_cities'].last['id']
            ].sort
          ).to eq(city_ids)
        end
      end
    end

    context 'when user is trying to access another user\'s data' do
      let(:another_user) { FactoryGirl.create(:user) }

      before do
        another_user.manual_cities << FactoryGirl.create(:city)
        another_user.save
      end

      it 'returns 403 error' do
        get 'index', params: { user_id: another_user.id }
        expect(response).to have_http_status 403
      end
    end
  end

  describe '#create' do
    before { login_user(user) }

    let(:city1) { FactoryGirl.create(:city) }
    let(:city2) { FactoryGirl.create(:city) }
    let(:manual_cities_ids) { [city1.id, city2.id] }
    let(:manual_cities_ids_short) { [city2.id] }

    context 'when user is trying to acess his own data' do
      context 'when list is initially empty' do
        it 'adds data' do
          post 'create', params: {
            user_id: user.id,
            manual_cities_ids: manual_cities_ids
          }
          expect(response).to have_http_status 200
          expect(user.reload.manual_cities.count).to eq(2)
        end
      end

      context 'when list is initially full' do
        before do
          user.manual_cities << city1
          user.manual_cities << city2
          user.save
        end

        it 'adds and deletes data' do
          expect(user.reload.manual_cities.count).to eq(2)
          post 'create', params: {
            user_id: user.id,
            manual_cities_ids: manual_cities_ids_short
          }
          expect(response).to have_http_status 200
          expect(user.reload.manual_cities.count).to eq(1)
        end
      end
    end

    context 'when user is trying to access another user\'s data' do
      let(:another_user) { FactoryGirl.create(:user) }

      it 'returns 403 error' do
        post 'create', params: {
          user_id: another_user.id,
          manual_cities_ids: manual_cities_ids
        }
        expect(response).to have_http_status 403
        expect(another_user.reload.manual_cities).to be_blank
      end
    end
  end
end
