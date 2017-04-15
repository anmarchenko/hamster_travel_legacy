# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::TripsController do
  let(:user) { FactoryGirl.create(:user) }

  describe '#index' do
    before do
      FactoryGirl.create(
        :trip,
        users: [user],
        name: 'tripppp',
        private: true,
        status_code: Trips::StatusCodes::FINISHED
      )
      FactoryGirl.create_list(
        :trip,
        2,
        status_code: Trips::StatusCodes::FINISHED
      )
    end

    context 'when user is logged in' do
      before { login_user(user) }

      it 'searches visible by user trips' do
        get 'index', params: { term: 'trippp' }
        json = JSON.parse(response.body)
        expect(json.count).to eq(1)
      end
    end

    context 'when no logged user' do
      it 'searches public trips' do
        get 'index', params: { term: 'trip' }
        json = JSON.parse(response.body)
        expect(json.count).to eq(2)
      end
    end
  end

  describe '#upload_image' do
    before { login_user(user) }
    let(:file) do
      fixture_file_upload(
        "#{::Rails.root}/spec/fixtures/files/cat.jpg", 'image/jpeg'
      )
    end

    context 'when current user is the author' do
      let(:trip) do
        FactoryGirl.create(
          :trip,
          author_user: user,
          users: [user]
        )
      end
      it 'uploads trip image' do
        post 'upload_image', params: { id: trip.id, file: file }
        expect(response).to be_success
        expect(trip.reload.image_uid).not_to be_blank
      end
    end

    context 'when current user is one of the participants' do
      let(:author) { FactoryGirl.create(:user) }
      let(:trip) do
        FactoryGirl.create(
          :trip,
          author_user: author,
          users: [subject.current_user, author]
        )
      end
      it 'uploads trip image' do
        post 'upload_image', params: { id: trip.id, file: file }
        expect(response).to be_success
        expect(trip.reload.image_uid).not_to be_blank
      end
    end

    context 'when current user is not included in trip' do
      let(:author) { FactoryGirl.create(:user) }
      let(:trip) do
        FactoryGirl.create(:trip, author_user: author, users: [author])
      end
      it 'returns forbidden code' do
        post 'upload_image', params: { id: trip.id, file: file }
        expect(response).to be_forbidden
        expect(trip.reload.image_uid).to be_blank
      end
    end
  end

  describe '#delete_image' do
    before { login_user(user) }

    let(:file) do
      fixture_file_upload(
        "#{::Rails.root}/spec/fixtures/files/cat.jpg", 'image/jpeg'
      )
    end

    before :each do
      trip.image = file
      trip.save
    end

    context 'when current user is the author' do
      let(:trip) do
        FactoryGirl.create(
          :trip,
          author_user: subject.current_user,
          users: [subject.current_user]
        )
      end
      it 'deletes trip image' do
        expect(trip.reload.image).not_to be_blank
        post 'delete_image', params: { id: trip.id }
        expect(response).to be_success
        expect(Travels::Trip.find(trip.id).image_uid).to be_blank
      end
    end

    context 'when current user is included in the trip' do
      let(:author) { FactoryGirl.create(:user) }
      let(:trip) do
        FactoryGirl.create(
          :trip,
          author_user: author,
          users: [subject.current_user, author]
        )
      end

      it 'deletes trip image' do
        expect(trip.reload.image).not_to be_blank
        post 'delete_image', params: { id: trip.id }
        expect(response).to be_success
        expect(Travels::Trip.find(trip.id).image_uid).to be_blank
      end
    end

    context 'when current user is not included in the trip' do
      let(:author) { FactoryGirl.create(:user) }
      let(:trip) do
        FactoryGirl.create(:trip, author_user: author, users: [author])
      end
      it 'deletes trip image' do
        expect(trip.reload.image).not_to be_blank
        post 'delete_image', params: { id: trip.id }
        expect(response).to be_forbidden
        expect(Travels::Trip.find(trip.id).image_uid).not_to be_blank
      end
    end
  end

  describe '#destroy' do
    context 'when user is logged in' do
      before { login_user(user) }

      context 'and when user is author' do
        let(:trip) do
          FactoryGirl.create(:trip, author_user: subject.current_user)
        end

        it 'marks trip as archived' do
          delete 'destroy', params: { id: trip.id }
          expect(Travels::Trip.where(id: trip.id).first).to be_nil
          expect(
            Travels::Trip.unscoped.where(id: trip.id, archived: true).first
          ).not_to be_blank
          expect(response).to have_http_status(:success)
        end

        it 'destroys all associated invites' do
          # create invite
          inviting_user = FactoryGirl.create(:user)
          Travels::TripInvite.create(
            inviting_user_id: inviting_user.id,
            invited_user_id: subject.current_user.id,
            trip_id: trip.id
          )

          expect(subject.current_user.incoming_invites.count).to eq(1)

          delete 'destroy', params: { id: trip.id }
          expect(Travels::Trip.where(id: trip.id).first).to be_nil

          expect(subject.current_user.incoming_invites.count).to eq(0)
        end
      end

      context 'and when user is just a participant' do
        let(:trip) { FactoryGirl.create(:trip, users: [subject.current_user]) }

        it 'returns json with forbidden code' do
          delete 'destroy', params: { id: trip.id }
          expect(response).to be_forbidden
          json = JSON.parse(response.body)
          expect(json['error']).to eq('forbidden')
        end
      end

      context 'and when trip does not exist' do
        it 'redirects to not found page' do
          delete 'destroy', params: { id: 'non existing' }
          expect(response).to redirect_to '/errors/not_found'
        end
      end
    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create(:trip) }

      it 'redirects to sign in' do
        delete 'destroy', params: { id: trip.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
