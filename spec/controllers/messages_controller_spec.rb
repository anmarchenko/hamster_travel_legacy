describe MessagesController do

  describe '#index' do

    context 'when user is logged in' do
      after { expect(response).to render_template 'messages/index' }

      login_user

      let(:trip) {FactoryGirl.create(:trip)}
      let(:some_user) {FactoryGirl.create(:user)}

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

end