# frozen_string_literal: true

require 'rails_helper'

def check_first_user(json, users)
  user = users.first
  expect(json.first).to eq('name' => user.full_name,
                           'code' => user.id.to_s,
                           'photo_url' => user.image_url,
                           'text' => user.full_name,
                           'initials' => user.initials,
                           'color' => user.background_color)
end

def check_users(body, term)
  users = User.find_by_term(term).page(1)
  json = JSON.parse(body)
  check_first_user(json, users)
  expect(json.count).to eq users.count
end

RSpec.describe Api::UsersController do
  let(:user) { FactoryGirl.create(:user) }

  describe '#index' do
    before do
      FactoryGirl.create_list(:user, 2, first_name: 'Sven',
                                        last_name: 'Petersson')
      FactoryGirl.create_list(:user, 3, first_name: 'Max',
                                        last_name: 'Mustermann')
      FactoryGirl.create_list(:user, 4)
    end

    context 'when user is logged in' do
      before { login_user(user) }

      after(:each) { Rails.cache.clear }

      it 'responds with empty array if term is shorter than 2 letters' do
        get 'index', params: { term: 'm' }, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'does not find logged user' do
        get 'index', params: { term: 'first' }, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body).count).to eq 4
      end

      it 'responds with empty array if term is blank' do
        get 'index', format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'responds with users when something found by first name' do
        term = 'ma'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        check_users response.body, term
      end

      it 'responds with users when something found by last name' do
        term = 'pet'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        check_users response.body, term
      end

      it 'responds with users when something found by lastname and firstname' do
        term = 'sven pet'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json.count).to eq 2
      end

      it 'finds several parts together always' do
        term = 'sven m'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'finds several parts together' do
        term = 'sven mu'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'responds with empty array if nothing found' do
        get 'index', params: { term: 'ivan ivanov' }, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end
    end

    context 'when no logged user' do
      it 'behaves the same as for logged user' do
        term = 'sve'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        check_users response.body, term
      end
    end
  end

  describe '#update' do
    let(:city) { FactoryGirl.create(:city) }
    let(:attrs) do
      {
        user: {
          first_name: 'Abraham',
          last_name: 'Lincoln',
          currency: 'GBP',
          locale: 'ru',
          home_town_id: city.id,
          email: 'new_email@mail.test'
        }
      }
    end

    context 'when user is logged in' do
      before { login_user(user) }

      context 'and when there is existing user' do
        context 'and when updates itself' do
          context 'when params are valid' do
            it 'updates user and returns json' do
              put 'update', params: attrs.merge(id: subject.current_user.id)
              expect(response).to have_http_status(200)
              json = JSON.parse(response.body)
              expect(json['error']).to eq(false)
              user = subject.current_user.reload
              expect(user.first_name).to eq('Abraham')
              expect(user.last_name).to eq('Lincoln')
              expect(user.currency).to eq('GBP')
              expect(user.locale).to eq('ru')
              expect(user.home_town_id).to eq(city.id)
              expect(user.email).not_to eq('new_email@mail.test')
            end
          end

          context 'when params are invalid' do
            let(:attrs) { { user: { first_name: 'Abraham', last_name: nil } } }
            it 'does not update user and returns errors' do
              put 'update', params: attrs.merge(id: subject.current_user.id)
              expect(response).to have_http_status(422)
              json = JSON.parse(response.body)
              expect(json['error']).to eq(true)
              expect(json['errors']['last_name']).to eq(["can't be blank"])
              user = subject.current_user.reload
              expect(user.first_name).not_to eq('Abraham')
              expect(user.last_name).not_to be_blank
            end
          end
        end

        context 'and when trying to update other user' do
          let(:new_user) { FactoryGirl.create(:user) }

          it 'redirects to dashboard with error' do
            put 'update', params: attrs.merge(id: new_user.id)
            expect(response).to have_http_status(403)
          end
        end
      end

      context 'and when there is no user' do
        it 'heads 404' do
          put 'update', params: attrs.merge(id: 'no_user_id')
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'when no logged user' do
      let(:new_user) { FactoryGirl.create(:user) }
      it 'redirects to sign in' do
        put 'update', params: attrs.merge(id: new_user.id)
        expect(response).to redirect_to('/users/sign_in')
      end
    end
  end

  describe '#visited' do
    before do
      # draft
      FactoryGirl.create(:trip, user_ids: [user.id])
      # finished, another user
      FactoryGirl.create(
        :trip,
        status_code: Trips::StatusCodes::FINISHED
      )
      FactoryGirl.create(
        :trip,
        :with_filled_days,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::PLANNED
      )
      FactoryGirl.create_list(
        :trip,
        2,
        :with_filled_days,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::FINISHED
      )
    end

    context 'when user is logged in' do
      before { login_user(user) }

      it 'returns list of countries and cities that user visited' do
        get 'visited', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['countries']).not_to be_blank
        expect(json['countries'].count).to eq(2)
        expect(json['cities']).not_to be_blank
        expect(json['cities'].count).to eq(2)
      end

      context 'when user added manual cities' do
        it 'returns list of countries and cities that user visited' do
          user.manual_cities << user.visited_cities.first
          user.manual_cities << FactoryGirl.create(:city)
          user.save

          get 'visited', params: { id: user.id }
          expect(response).to have_http_status(200)

          json = JSON.parse(response.body)
          expect(json['countries']).not_to be_blank
          expect(json['countries'].count).to eq(3)
          expect(json['cities']).not_to be_blank
          expect(json['cities'].count).to eq(3)
        end
      end
    end
  end

  describe '#finished_trips' do
    context 'when user is logged in' do
      before do
        # finished, another user
        FactoryGirl.create(
          :trip,
          status_code: Trips::StatusCodes::FINISHED
        )
        FactoryGirl.create(
          :trip,
          user_ids: [user.id],
          status_code: Trips::StatusCodes::PLANNED
        )
        FactoryGirl.create_list(
          :trip,
          3,
          user_ids: [user.id],
          status_code: Trips::StatusCodes::FINISHED
        )
      end
      before { login_user(user) }

      it "returns list of the user's finished trips" do
        get 'finished_trips', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['trips'].count).to eq(3)
      end
    end

    context 'when no logged user' do
      before do
        FactoryGirl.create_list(
          :trip,
          10,
          user_ids: [user.id],
          status_code: Trips::StatusCodes::FINISHED
        )
      end
      it "returns list of the last 3 user's finished trips" do
        get 'finished_trips', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['trips'].count).to eq(3)
      end
    end
  end

  describe '#planned_trips' do
    before do
      FactoryGirl.create(
        :trip,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::FINISHED
      )
      FactoryGirl.create_list(
        :trip,
        2,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::PLANNED
      )
      FactoryGirl.create(
        :trip,
        private: true,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::PLANNED
      )
    end
    context 'when user is logged in' do
      before { login_user(user) }

      it "returns list of the user's planned trips including private" do
        get 'planned_trips', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['trips'].count).to eq(3)
      end
    end

    context 'when no logged user' do
      it "returns list of the user's planned trips excluding private" do
        get 'planned_trips', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['trips'].count).to eq(2)
      end
    end
  end

  describe '#show' do
    before do
      # draft
      FactoryGirl.create(:trip, user_ids: [user.id])
      # finished, another user
      FactoryGirl.create(
        :trip,
        status_code: Trips::StatusCodes::FINISHED
      )
      FactoryGirl.create(
        :trip,
        :with_filled_days,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::PLANNED
      )
      FactoryGirl.create_list(
        :trip,
        2,
        :with_filled_days,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::FINISHED
      )
    end

    context 'when user is logged in' do
      before { login_user(user) }

      it 'returns user with information about trips, countries and cities' do
        get 'show', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['user']).not_to be_blank
        user_json = json['user']
        expect(user_json['email']).to be_blank
        expect(user_json['id'].to_s).to eq(user.id.to_s)
        expect(user_json['color']).to eq(user.background_color)
        expect(user_json['initials']).to eq(user.initials)
        expect(user_json['home_town_text']).to eq(user.home_town_text)

        expect(user_json['finished_trips_count']).to eq(2)
        expect(user_json['visited_cities_count']).to eq(2)
        expect(user_json['visited_countries_count']).to eq(2)
      end

      context 'when user added manual cities' do
        before do
          user.manual_cities << user.visited_cities.first
          user.manual_cities << FactoryGirl.create(:city)
          user.save
        end

        it 'returns user information counting manual cities' do
          get 'show', params: { id: user.id }
          expect(response).to have_http_status(200)

          json = JSON.parse(response.body)
          expect(json['user']).not_to be_blank
          user_json = json['user']

          expect(user_json['finished_trips_count']).to eq(2)
          expect(user_json['visited_cities_count']).to eq(3)
          expect(user_json['visited_countries_count']).to eq(3)
        end
      end
    end

    context 'when no logged user' do
      it 'returns same information' do
        get 'show', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['user']).not_to be_blank
        user_json = json['user']
        expect(user_json['email']).to be_blank
        expect(user_json['id'].to_s).to eq(user.id.to_s)
      end
    end
  end
end
