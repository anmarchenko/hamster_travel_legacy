describe UsersController do
  describe '#show' do
    context 'when user is logged in' do
      login_user

      context 'where there is user and his trips' do
        before {FactoryGirl.create_list(:trip, 5, users: [subject.current_user])}

        it 'renders show template with trips' do
          get 'show', id: subject.current_user.id
          user = assigns(:user)
          expect(user).to eq subject.current_user
          trips = assigns(:trips)
          expect(trips.count).to eq 5
          trips.each do |trip|
            expect(trip.include_user(user)).to be true
          end
          expect(response).to render_template 'users/show'
        end
      end

      context 'when there is no user' do
        it 'heads 404' do
          get 'show', id: 'no user'
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      let(:user) {FactoryGirl.create(:user)}
      context 'where there is user and his trips' do
        before {FactoryGirl.create_list(:trip, 5, users: [user])}

        it 'renders show template with trips' do
          get 'show', id: user.id
          user_assigned = assigns(:user)
          expect(user_assigned).to eq user
          trips = assigns(:trips)
          expect(trips.count).to eq 5
          trips.each do |trip|
            expect(trip.include_user(user)).to be true
          end
        end
      end
    end
  end

end