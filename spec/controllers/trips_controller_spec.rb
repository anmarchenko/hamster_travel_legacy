describe TripsController do

  let(:attrs) {FactoryGirl.build(:trip).attributes}

  describe '#index' do

    after {expect(response).to render_template 'trips/index'}

    context 'when user is logged in' do
      login_user

      before {FactoryGirl.create_list(:trip, 6, user_ids: [subject.current_user.id])}
      before {FactoryGirl.create_list(:trip, 12)}

      it 'shows trips index page' do
        get 'index'
        trips = assigns(:trips)
        expect(trips.to_a.count).to eq 9
      end

      it 'shows user\'s trips when parameter \'my\' is present' do
        get 'index', my: true
        trips = assigns(:trips)
        expect(trips.to_a.count).to eq 6
        trips.each do |trip|
          expect(trip.include_user(subject.current_user)).to be true
        end
      end

    end

    context 'when no logged user' do
      before {FactoryGirl.create_list(:trip, 12)}
      after {expect(assigns(:trips).to_a.count).to eq 9 }

      it 'shows trips index page' do
        get 'index'
      end

      it 'shows same trips when parameter \'my\' is present' do
        get 'index', my: true
      end

    end
  end

  describe '#new' do
    context 'when user is logged in' do
      login_user

      it 'renders template with new trip' do
        get 'new'
        expect(assigns(:trip)).to be_a_new Travels::Trip
        expect(response).to render_template 'trips/new'
      end
    end

    context 'when no logged user' do
      it "respond with not authorized status" do
        get 'new'
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#create' do
    context 'when user is logged in' do
      login_user

      context 'and when trip is valid' do
        let(:params) { {travels_trip: attrs} }

        it 'creates new trip and redirects to show' do
          post 'create', params
          trip = assigns(:trip)
          expect(response).to redirect_to trip_path(trip)
          expect(trip).to be_persisted
          expect(trip.author_user).to eq subject.current_user
          expect(trip.users).to eq [subject.current_user]
          expect(trip.name).to eq params[:travels_trip]['name']
          expect(trip.short_description).to eq params[:travels_trip]['short_description']
          expect(trip.start_date).to eq params[:travels_trip]['start_date']
          expect(trip.end_date).to eq params[:travels_trip]['end_date']
        end
      end

      context 'and when trip is valid with forbidden attribute' do
        let(:params) { {travels_trip: attrs.merge(published: true)} }

        it 'creates new trip and redirects to show' do
          post 'create', params
          trip = assigns(:trip)
          expect(trip).to be_persisted
          expect(trip.name).to eq params[:travels_trip]['name']
          expect(trip.published).to be false
        end
      end

      context 'and when trip is not valid' do
        let(:params) { {travels_trip: attrs.reject { |k, _| k == 'name' }} }

        it 'creates new trip and redirects to show' do
          post 'create', params
          trip = assigns(:trip)
          expect(response).to render_template 'trips/new'
          expect(trip).not_to be_persisted
          expect(trip.errors).not_to be_blank
        end
      end

    end

    context 'when no logged user' do
      let(:params) { {travels_trip: attrs} }

      it 'redirects to sign in' do
        post 'create', params
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#edit' do
    context 'when user is logged in' do
      login_user

      context 'and when user is included in this trip' do
        let(:trip) {FactoryGirl.create(:trip, users: [subject.current_user])}

        it 'renders edit template' do
          get 'edit', id: trip.id
          expect(response).to render_template 'trips/edit'
        end
      end

      context 'and when user is not included in this trip' do
        let(:trip) {FactoryGirl.create(:trip, author_user: subject.current_user)}

        it 'redirects to dashboard with flash' do
          get 'edit', id: trip.id
          expect(response).to redirect_to '/'
          expect(flash[:error]).to eq I18n.t('errors.unathorized')
        end
      end

      context 'and when trip does not exist' do
        it 'heads code 404' do
          get 'edit', id: 'not-existing-id'
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create(:trip)}

      it 'redirects to sign in' do
        get 'edit', id: trip.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    let(:update_attrs) {{travels_trip: attrs.merge('name' => 'New Updated Name'), id: trip.id}}
    context 'when user is logged in' do
      login_user

      context 'and when user is included in this trip' do
        let(:trip) {FactoryGirl.create(:trip, users: [subject.current_user])}

        context 'and when params are valid' do
          it 'updates trip and redirects to show with notice' do
            put 'update', update_attrs
            expect(assigns(:trip).name).to eq 'New Updated Name'
            expect(response).to redirect_to trip_path(trip)
            expect(flash[:notice]).to eq I18n.t('common.update_successful')
          end
        end

        context 'and when params are not valid' do
          let(:update_attrs_invalid) {{travels_trip: attrs.merge('name' => nil), id: trip.id}}
          it 'renders edit template' do
            put 'update', update_attrs_invalid
            expect(assigns(:trip).errors).not_to be_blank
            expect(response).to render_template 'trips/edit'
          end
        end
      end

      context 'and when user is not included in this trip' do
        let(:trip) {FactoryGirl.create(:trip, author_user: subject.current_user)}

        it 'redirects to dashboard with flash' do
          put 'update', update_attrs
          expect(response).to redirect_to '/'
          expect(assigns(:trip).name).to eq trip.name
        end
      end

    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create(:trip)}

      it 'redirects to sign in' do
        put 'update', update_attrs
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#show' do
    context 'when user is logged in' do
      login_user

      context 'and when trip exists' do
        let(:trip) {FactoryGirl.create(:trip)}
        it 'renders show template' do
          get 'show', id: trip.id
          expect(response).to render_template 'trips/show'
          expect(assigns(:trip).id).to eq trip.id
        end
      end

      context 'and when trip does not exist' do
        it 'renders show template' do
          get 'show', id: 'non-existing-id'
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create(:trip)}

      it 'renders show template' do
        get 'show', id: trip.id
        expect(response).to have_http_status 200
        expect(response).to render_template 'trips/show'
      end
    end
  end

  describe '#destroy' do
    context 'when user is logged in' do
      login_user

      context 'and when user is author' do
        let(:trip) {FactoryGirl.create(:trip, author_user: subject.current_user)}

        it 'destroys the trip completely' do
          delete 'destroy', id: trip.id
          expect(Travels::Trip.where(id: trip.id).first).to be_nil
          expect(response).to redirect_to trips_path(my: true)
        end
      end

      context 'and when user is just a participant' do
        let(:trip) {FactoryGirl.create(:trip, users: [subject.current_user])}

        it 'redirects to dashboard with flash' do
          delete 'destroy', id: trip.id
          expect(response).to redirect_to '/'
          expect(flash[:error]).to eq I18n.t('errors.unathorized')
        end
      end

      context 'and when trip does not exist' do
        it 'heads 404' do
          delete 'destroy', id: 'non existing'
          expect(response).to have_http_status 404
        end
      end
    end

    context 'when no logged user' do
      let(:trip) {FactoryGirl.create(:trip)}

      it 'redirects to sign in' do
        delete 'destroy', id: trip.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

end