describe UsersController do

  let(:attrs) {FactoryGirl.build(:user).attributes}

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

  describe '#edit' do
    context 'when user is logged in' do
      login_user

      context 'and when there is user' do
        it 'renders edit template' do
          get 'edit', id: subject.current_user.id
          expect(response).to render_template 'users/edit'
        end
      end

      context 'and when user wants to edit someone other than himself' do
        let(:new_user) {FactoryGirl.create(:user)}
        it 'redirects to dashboard with error' do
          get 'edit', id: new_user.id
          expect(response).to redirect_to '/'
          expect(flash[:error]).to eq I18n.t('errors.unathorized')
        end
      end

      context 'and when there is no user' do
        it 'heads 404' do
          get 'edit', id: 'no user'
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      let(:new_user) {FactoryGirl.create(:user)}
      it 'redirects to sign in' do
        get 'edit', id: new_user.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    let(:update_attrs) {{ user: attrs.merge(home_town_text: 'new home town text')}}

    context 'when user is logged in' do
      login_user

      context 'and when there is updated user' do
      end

      context 'and when there is no user' do
        it 'heads 404' do
          put 'update', update_attrs.merge(id: 'no_user_id')
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
    end
  end


end