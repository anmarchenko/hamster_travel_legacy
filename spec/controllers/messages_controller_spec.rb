describe MessagesController do

  describe '#index' do

    context 'when user is logged in' do
      after { expect(response).to render_template 'messages/index' }

      login_user

      let(:trip) { FactoryGirl.create(:trip) }
      let(:some_user) { FactoryGirl.create(:user) }

      before do
        Travels::TripInvite.create(trip: trip, inviting_user: some_user, invited_user: subject.current_user)
      end

      it 'shows trips index page, all trips that are not draft' do
        get 'index'
        invites = assigns(:invites)
        expect(invites.count).to eq(1)
        expect(invites.first.trip).to eq(trip)
        expect(invites.first.inviting_user).to eq(some_user)
        expect(invites.first.invited_user).to eq(subject.current_user)
      end

    end

    context 'when no logged user' do
      it 'redirects to sign in' do
        get 'index'
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#destroy' do

    context 'when user is logged in' do
      login_user

      let(:trip) { FactoryGirl.create(:trip) }
      let(:some_user) { FactoryGirl.create(:user) }
      let(:trip_invite) { Travels::TripInvite.create(trip: trip, inviting_user: some_user, invited_user: subject.current_user) }
      let(:another_invite) { Travels::TripInvite.create(trip: trip, inviting_user: some_user, invited_user: some_user) }

      context 'and when there are trip_invite' do
        context 'and when user is invited' do
          it 'deletes trip_invite' do
            delete 'destroy', id: trip_invite.id
            expect(response).to have_http_status(200)

            json = JSON.parse(response.body)
            expect(json['success']).to eq(true)

            expect(Travels::TripInvite.where(id: trip_invite.id).first).to be_nil
          end
        end

        context 'and when user is not invited' do
          it 'respons with not authorized' do
            delete 'destroy', id: another_invite.id
            expect(response).to have_http_status(403)
            expect(Travels::TripInvite.where(id: another_invite.id).first).not_to be_nil
          end
        end
      end

      context 'and when there are no invite' do
        it 'responds with not found' do
          delete 'destroy', id: '404 LOL'
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'when no logged user' do
      it 'redirects to sign in' do
        delete 'destroy', id: 1
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#updates' do

    context 'when user is logged in' do
      login_user

      let(:trip) { FactoryGirl.create(:trip) }
      let(:some_user) { FactoryGirl.create(:user) }
      let(:trip_invite) { Travels::TripInvite.create(trip: trip, inviting_user: some_user, invited_user: subject.current_user) }
      let(:another_invite) { Travels::TripInvite.create(trip: trip, inviting_user: some_user, invited_user: some_user) }

      context 'and when there are trip_invite' do
        context 'and when user is invited' do
          it 'deletes trip_invite' do
            put 'update', id: trip_invite.id
            expect(response).to have_http_status(200)

            json = JSON.parse(response.body)
            expect(json['success']).to eq(true)

            expect(Travels::TripInvite.where(id: trip_invite.id).first).to be_nil
            expect(trip.reload.include_user(subject.current_user)).to eq(true)
          end
        end

        context 'and when user is not invited' do
          it 'respons with not authorized' do
            put 'update', id: another_invite.id
            expect(response).to have_http_status(403)
            expect(Travels::TripInvite.where(id: another_invite.id).first).not_to be_nil
          end
        end
      end

      context 'and when there are no invite' do
        it 'responds with not found' do
          put 'update', id: '404 LOL'
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'when no logged user' do
      it 'redirects to sign in' do
        put 'update', id: 1
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

end