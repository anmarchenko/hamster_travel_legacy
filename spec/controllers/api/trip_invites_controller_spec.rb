describe Api::TripInvitesController do
  describe '#create' do
    let(:trip_without_user) { FactoryGirl.create :trip }

    context 'when user is logged in' do
      login_user

      let(:trip) { FactoryGirl.create :trip, users: [subject.current_user] }
      let(:some_user) { FactoryGirl.create :user }

      context 'and when there is trip' do

        context 'and when input params are valid' do
          it 'creates trip_invite and renders success' do
            post 'create', id: trip.id, user_id: some_user.id, format: :json
            expect(response).to have_http_status 200

            json = JSON.parse(response.body)
            expect(json['success']).to eq(true)
            expect(trip.reload.pending_invites.count).to eq(1)
            expect(some_user.reload.incoming_invites.count).to eq(1)
            expect(subject.current_user.reload.outgoing_invites.count).to eq(1)
            expect(some_user.reload.incoming_invites.first).to eq(subject.current_user.reload.outgoing_invites.first)
            expect(some_user.reload.incoming_invites.first).to eq(trip.reload.pending_invites.first)
          end

          it 'does not create twice' do
            post 'create', id: trip.id, user_id: some_user.id, format: :json
            expect(response).to have_http_status 200
            json = JSON.parse(response.body)
            expect(json['success']).to eq(true)

            post 'create', id: trip.id, user_id: some_user.id, format: :json
            expect(response).to have_http_status 200
            json = JSON.parse(response.body)
            expect(json['success']).to eq(false)
            expect(trip.reload.pending_invites.count).to eq(1)
          end
        end

        context 'and when trying to invite user, that is already in trip' do
          let(:user_in_trip) { FactoryGirl.create :user }
          let(:trip_with_user) { FactoryGirl.create :trip, users: [subject.current_user, user_in_trip] }

          it 'does not create invite' do
            post 'create', id: trip_with_user.id, user_id: user_in_trip.id, format: :json
            expect(response).to have_http_status 200
            json = JSON.parse(response.body)
            expect(json['success']).to eq(false)
            expect(trip.reload.pending_invites.count).to eq(0)
          end
        end

        context 'and when trying to invite non existing user' do

          it 'does not create invite' do
            post 'create', id: trip.id, user_id: 'lolol', format: :json
            expect(response).to have_http_status 200
            json = JSON.parse(response.body)
            expect(json['success']).to eq(false)
            expect(trip.reload.pending_invites.count).to eq(0)
          end
        end

        context 'and when user is not included in trip' do
          it 'heads 403' do
            post 'create', id: trip_without_user.id, user_id: some_user.id, format: :json
            expect(response).to have_http_status 403
          end
        end

      end

      context 'and when there is no trip' do
        it 'heads 404' do
          post 'create', id: 'pff', user_id: some_user.id, format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create :trip }
      let(:some_user) { FactoryGirl.create :user }
      it 'returns unathenticated' do
        post 'create', id: trip.id, user_id: some_user.id, format: :json
        expect(response).to have_http_status 401
      end
    end
  end

  describe '#destroy' do

    context 'when user is logged in' do
      login_user

      let(:some_user) { FactoryGirl.create :user }
      let(:trip) { FactoryGirl.create :trip, :with_invited, users: [subject.current_user, some_user],
                                      author_user: subject.current_user }

      let(:another_trip) { FactoryGirl.create :trip, users: [subject.current_user, some_user] }

      context 'when requested to delete participant' do
        it 'deletes participant from trip' do
          delete 'destroy', id: trip.id, user_id: some_user.id, format: :json
          expect(response).to have_http_status(200)
          expect(trip.reload.include_user(subject.current_user)).to eq(true)
          expect(trip.reload.include_user(some_user)).to eq(false)
          expect(User.find(some_user.id)).to eq(some_user)
          expect(trip.reload.pending_invites.count).to eq(1)
        end
      end

      context 'when requested to delete invited user' do
        it 'deletes participant from trip' do
          delete 'destroy', id: trip.id, trip_invite_id: trip.invited_users.first.id, format: :json
          expect(response).to have_http_status(200)
          expect(trip.reload.include_user(subject.current_user)).to eq(true)
          expect(trip.reload.include_user(some_user)).to eq(true)
          expect(trip.reload.pending_invites.count).to eq(0)
        end
      end

      context 'when user is not author' do
        it 'returns unauthorized error' do
          delete 'destroy', id: another_trip.id, user_id: some_user.id, format: :json
          expect(response).to have_http_status(403)
        end
      end

      context 'when tries to delete author' do
        it 'returns unauthorized error' do
          delete 'destroy', id: trip.id, user_id: subject.current_user.id, format: :json
          expect(response).to have_http_status(403)
        end
      end

    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create :trip }
      let(:some_user) { FactoryGirl.create :user }

      it 'returns unathenticated' do
        delete 'destroy', id: trip.id, user_id: some_user.id, format: :json
        expect(response).to have_http_status 401
      end
    end

  end

end