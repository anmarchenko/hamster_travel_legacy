describe TripsController do

  let(:attrs) { FactoryGirl.build(:trip).attributes }
  let(:attrs_no_dates) { FactoryGirl.build(:trip, :no_dates).attributes }

  describe '#index' do

    after { expect(response).to render_template 'trips/index' }

    context 'when user is logged in' do
      login_user

      before { Travels::Trip.destroy_all }

      before { FactoryGirl.create_list(:trip, 2, user_ids: [subject.current_user.id]) }
      before { FactoryGirl.create_list(:trip, 1, :no_dates, user_ids: [subject.current_user.id]) }

      before { FactoryGirl.create_list(:trip, 1, user_ids: [subject.current_user.id],
                                       status_code: Travels::Trip::StatusCodes::FINISHED) }
      before { FactoryGirl.create_list(:trip, 4, user_ids: [subject.current_user.id],
                                       status_code: Travels::Trip::StatusCodes::PLANNED) }

      before { FactoryGirl.create_list(:trip, 12) }
      before { FactoryGirl.create_list(:trip, 2, status_code: Travels::Trip::StatusCodes::FINISHED) }

      before { FactoryGirl.create_list(:trip, 1, user_ids: [subject.current_user.id],
                                       private: true, status_code: Travels::Trip::StatusCodes::FINISHED) }

      it 'shows trips index page, all trips that are not draft' do
        get 'index'
        trips = assigns(:trips)
        expect(trips.to_a.count).to eq 7
        # check sort
        trips.each_index do |i|
          next if trips[i+1].blank?
          expect(
              trips[i].status_code > trips[i+1].status_code ||
                  (
                  trips[i].status_code == trips[i+1].status_code &&
                      trips[i].start_date >= trips[i+1].start_date
                  )
          ).to be true
          expect(trips[i].private).to be false
        end
      end

      it 'shows user\'s plans without drafts when parameter \'my\' is present' do
        get 'index', my: true
        trips = assigns(:trips)
        expect(trips.to_a.count).to eq 6
        trips.each_with_index do |trip, i|
          expect(trip.include_user(subject.current_user)).to be true
          expect(trip.status_code).not_to eq(Travels::Trip::StatusCodes::DRAFT)

          next if trips[i+1].blank?
          expect(
              trips[i].start_date >= trips[i+1].start_date
          ).to be true
        end
      end
      it 'shows user\'s drafts when parameter \'my_draft\' is present' do
        get 'index', my_draft: true
        trips = assigns(:trips)
        expect(trips.to_a.count).to eq 3
        trips.each do |trip|
          expect(trip.include_user(subject.current_user)).to be true
          expect(trip.status_code).to eq(Travels::Trip::StatusCodes::DRAFT)
        end
      end

      it 'shows trips without dates last' do
        get 'index', my_draft: true
        trips = assigns(:trips)
        expect(trips.to_a.count).to eq 3
        expect(trips.first.start_date).not_to be_nil
        expect(trips.last.start_date).to be_nil
      end

    end

    context 'when no logged user' do
      before { Travels::Trip.destroy_all }
      before { FactoryGirl.create_list(:trip, 12) }
      before { FactoryGirl.create_list(:trip, 3, status_code: Travels::Trip::StatusCodes::PLANNED) }
      after { expect(assigns(:trips).to_a.count).to eq 3 }

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

      context 'when parameter copy from present' do
        let(:trip) { FactoryGirl.create(:trip, :with_filled_days, currency: 'USD') }
        let(:trip_private) { FactoryGirl.create(:trip, :with_filled_days, private: true) }
        context 'and when it is valid existing trip id' do
          it 'renders template with new trip copied from old trip' do
            get 'new', copy_from: trip.id
            new_trip = assigns(:trip)
            expect(new_trip.currency).to eq 'USD'
            expect(new_trip.name).to eq trip.name + " (#{I18n.t('common.copy')})"
            expect(new_trip.start_date).to eq trip.start_date
            expect(new_trip.end_date).to eq trip.end_date
            expect(new_trip.short_description).to be_nil

            expect(new_trip.comment).to be_nil
            expect(new_trip.archived).to be false
            expect(new_trip.private).to be false
            expect(new_trip.image_uid).to be_nil
            expect(new_trip.status_code).to eq Travels::Trip::StatusCodes::DRAFT
          end
        end

        context 'and when trying to copy private trip' do
          it 'just creates new trip' do
            get 'new', copy_from: trip_private.id
            new_trip = assigns(:trip)
            expect(new_trip.name).to be_nil
            expect(new_trip.start_date).to be_nil
            expect(new_trip.end_date).to be_nil
            expect(new_trip.short_description).to be_nil

            expect(new_trip.comment).to be_nil
            expect(new_trip.archived).to be false
            expect(new_trip.private).to be false
            expect(new_trip.image_uid).to be_nil
            expect(new_trip.status_code).to eq Travels::Trip::StatusCodes::DRAFT

            expect(assigns(:original_trip)).to be_nil
          end
        end

        context 'and when it is not valid' do
          it 'renders template with new trip' do
            get 'new', copy_from: 'blahblah'
            new_trip = assigns(:trip)
            expect(new_trip.name).to be_nil
            expect(new_trip.start_date).to be_nil
            expect(new_trip.end_date).to be_nil
            expect(new_trip.short_description).to be_nil

            expect(new_trip.comment).to be_nil
            expect(new_trip.archived).to be false
            expect(new_trip.private).to be false
            expect(new_trip.image_uid).to be_nil
            expect(new_trip.status_code).to eq Travels::Trip::StatusCodes::DRAFT
          end
        end

        context 'and when it is empty' do
          it 'renders template with new trip' do
            get 'new', copy_from: ''
            new_trip = assigns(:trip)
            expect(new_trip.name).to be_nil
            expect(new_trip.start_date).to be_nil
            expect(new_trip.end_date).to be_nil
            expect(new_trip.short_description).to be_nil

            expect(new_trip.comment).to be_nil
            expect(new_trip.archived).to be false
            expect(new_trip.private).to be false
            expect(new_trip.image_uid).to be_nil
            expect(new_trip.status_code).to eq Travels::Trip::StatusCodes::DRAFT
          end
        end
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
        let(:params) { {travels_trip: attrs.merge(currency: 'INR')} }

        it 'creates new trip and redirects to show' do
          post 'create', params
          trip = assigns(:trip).reload
          expect(response).to redirect_to trip_path(trip)
          expect(trip).to be_persisted
          expect(trip.author_user).to eq subject.current_user
          expect(trip.users).to eq [subject.current_user]
          expect(trip.name).to eq params[:travels_trip]['name']
          expect(trip.short_description).to eq params[:travels_trip]['short_description']
          expect(trip.start_date).to eq params[:travels_trip]['start_date']
          expect(trip.end_date).to eq params[:travels_trip]['end_date']
          expect(trip.currency).to eq('INR')
          expect(trip.days.first.hotel.amount_currency).to eq('INR')
        end

        context 'and when trip is without dates' do

          let(:params) { {travels_trip: attrs_no_dates} }

          it 'creates new trip and redirects to show' do
            post 'create', params
            trip = assigns(:trip).reload
            expect(trip).to be_persisted
            expect(response).to redirect_to trip_path(trip)

            expect(trip.author_user).to eq subject.current_user
            expect(trip.users).to eq [subject.current_user]
            expect(trip.name).to eq params[:travels_trip]['name']
            expect(trip.short_description).to eq params[:travels_trip]['short_description']
            expect(trip.start_date).to eq nil
            expect(trip.end_date).to eq nil
            expect(trip.days_count).to eq 3
            expect(trip.planned_days_count).to eq 3
            expect(trip.currency).to eq('RUB')
          end

        end

        context 'and when trip is copied from original' do

          let(:original) { FactoryGirl.create(:trip, :with_filled_days) }
          let(:original_private) { FactoryGirl.create(:trip, :with_filled_days, private: true) }

          context 'and when it is valid existing trip id' do
            it 'renders template with new trip copied from old trip' do
              post 'create', params.merge(copy_from: original.id)
              trip = assigns(:trip)
              trip = trip.reload

              expect(trip.comment).to be_nil
              expect(trip.days.count).to eq(original.days.count)

              expect(trip.days.first.comment).to eq original.days.first.comment
              expect(trip.days.first.date_when).to eq params[:travels_trip]['start_date']
              expect(trip.days.first.transfers.count).to eq original.days.first.transfers.count
              expect(trip.days.first.transfers.first.amount).to eq original.days.first.transfers.first.amount

              expect(trip.days.first.places.count).to eq original.days.first.places.count
              expect(trip.days.first.hotel.name).to eq original.days.first.hotel.name

              expect(trip.days.last.comment).to eq original.days.last.comment
              expect(trip.days.last.date_when).to eq params[:travels_trip]['end_date']

              expect(trip.caterings.count).to eq(original.caterings.count)
              new_names_caterings = trip.caterings.map{|c| c.name}.sort
              old_names_caterings = original.caterings.map{|c| c.name}.sort
              expect(new_names_caterings).to eq(old_names_caterings)
            end
          end

          context 'and when trying to copy private trip' do
            it 'just creates new trip' do
              post 'create', params.merge(copy_from: original_private.id)
              trip = assigns(:trip)
              trip = trip.reload
              expect(trip.days.first.comment).to be_nil
              expect(trip.days.first.date_when).to eq params[:travels_trip]['start_date']
              expect(trip.days.first.transfers.count).to eq 0

              expect(trip.days.last.comment).to be_nil
              expect(trip.days.last.date_when).to eq params[:travels_trip]['end_date']
            end
          end

          context 'and when it is not valid' do
            it 'renders template with new trip' do
              post 'create', params.merge(copy_from: 'fdsfdsfdfds')
              trip = assigns(:trip)
              trip = trip.reload
              expect(trip.days.first.comment).to be_nil
              expect(trip.days.first.date_when).to eq params[:travels_trip]['start_date']
              expect(trip.days.first.transfers.count).to eq 0

              expect(trip.days.last.comment).to be_nil
              expect(trip.days.last.date_when).to eq params[:travels_trip]['end_date']
            end
          end

          context 'and when it has more days than original trip' do
            it 'renders template with new trip' do
              ps = params.merge(copy_from: original.id)
              ps[:travels_trip]['end_date'] += 1.day

              post 'create', ps
              trip = assigns(:trip)
              trip = trip.reload

              expect(trip.start_date).to eq(ps[:travels_trip]['start_date'])
              expect(trip.end_date).to eq(ps[:travels_trip]['end_date'])

              expect(trip.days.first.comment).to eq original.days.first.comment
              expect(trip.days.first.date_when).to eq params[:travels_trip]['start_date']
              expect(trip.days.first.transfers.count).to eq original.days.first.transfers.count
              expect(trip.days.first.transfers.first.amount).to eq original.days.first.transfers.first.amount

              expect(trip.days.last.comment).to be_nil
              expect(trip.days.last.date_when).to eq params[:travels_trip]['end_date']
            end
          end

          context 'and when it has less days than original trip' do
            it 'renders template with new trip' do
              ps = params.merge(copy_from: original.id)
              ps[:travels_trip]['end_date'] -= 1.day

              post 'create', ps
              trip = assigns(:trip)
              trip = trip.reload

              expect(trip.days.first.comment).to eq original.days.first.comment
              expect(trip.days.first.date_when).to eq params[:travels_trip]['start_date']
              expect(trip.days.first.transfers.count).to eq original.days.first.transfers.count
              expect(trip.days.first.transfers.first.amount).to eq original.days.first.transfers.first.amount

              expect(trip.days.last.comment).to eq original.days[-2].comment
              expect(trip.days.last.date_when).to eq params[:travels_trip]['end_date']
            end
          end

        end
      end

      context 'and when trip is valid with forbidden attribute' do
        let(:params) { {travels_trip: attrs.merge(archived: true)} }

        it 'creates new trip and redirects to show' do
          post 'create', params
          trip = assigns(:trip)
          expect(trip).to be_persisted
          expect(trip.name).to eq params[:travels_trip]['name']
          expect(trip.archived).to be false
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
        let(:trip) { FactoryGirl.create(:trip, users: [subject.current_user]) }

        it 'renders edit template' do
          get 'edit', id: trip.id
          expect(response).to render_template 'trips/edit'
        end
      end

      context 'and when user is not included in this trip' do
        let(:trip) { FactoryGirl.create(:trip, author_user: subject.current_user) }

        it 'redirects to dashboard with flash' do
          get 'edit', id: trip.id
          expect(response).to redirect_to '/errors/no_access'
        end
      end

      context 'and when trip does not exist' do
        it 'heads code 404' do
          get 'edit', id: 'not-existing-id'
          expect(response).to redirect_to '/errors/not_found'
        end
      end
    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create(:trip) }

      it 'redirects to sign in' do
        get 'edit', id: trip.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#update' do
    let(:update_attrs) { {travels_trip: attrs.merge('name' => 'New Updated Name',
                                                    status_code: Travels::Trip::StatusCodes::PLANNED,
                                                    private: true, currency: 'EUR'), id: trip.id} }
    context 'when user is logged in' do
      login_user

      context 'and when user is included in this trip' do
        let(:trip) { FactoryGirl.create(:trip, users: [subject.current_user]) }

        context 'and when params are valid' do
          it 'updates trip and redirects to show with notice' do
            put 'update', update_attrs
            trip_updated = assigns(:trip).reload
            expect(trip_updated.name).to eq 'New Updated Name'
            expect(trip_updated.status_code).to eq Travels::Trip::StatusCodes::PLANNED
            expect(trip_updated.private).to eq true
            expect(trip_updated.currency).to eq('EUR')
            expect(response).to redirect_to trip_path(trip)
            expect(flash[:notice]).to eq I18n.t('common.update_successful')
          end

          context 'when number of days changes' do
            let(:update_attrs) { {travels_trip: attrs.merge('name' => 'New Updated Name',
                                                            start_date: Date.today, end_date: Date.today + 1.day,
                                                            status_code: Travels::Trip::StatusCodes::PLANNED,
                                                            private: true, currency: 'EUR'), id: trip.id} }
            context 'when there is one catering' do
              let(:trip) {FactoryGirl.create(:trip, :with_filled_days, users: [subject.current_user])}

              it 'updates catering days accordingly' do
                trip.caterings = [FactoryGirl.build(:catering)]
                trip.save

                put 'update', update_attrs
                trip_updated = assigns(:trip).reload
                expect(trip_updated.name).to eq 'New Updated Name'
                expect(trip_updated.status_code).to eq Travels::Trip::StatusCodes::PLANNED
                expect(trip_updated.private).to eq true

                expect(trip_updated.start_date).to eq(Date.today)
                expect(trip_updated.end_date).to eq(Date.today + 1.day)
                expect(trip_updated.caterings.first.days_count).to eq(2)
              end
            end
          end
        end

        context 'and when params are not valid' do
          let(:update_attrs_invalid) { {travels_trip: attrs.merge('name' => nil), id: trip.id} }
          it 'renders edit template' do
            put 'update', update_attrs_invalid
            expect(assigns(:trip).errors).not_to be_blank
            expect(response).to render_template 'trips/edit'
          end
        end
      end

      context 'and when user is not included in this trip' do
        let(:trip) { FactoryGirl.create(:trip, author_user: subject.current_user) }

        it 'redirects to dashboard with flash' do
          put 'update', update_attrs
          expect(response).to redirect_to '/errors/no_access'
          expect(assigns(:trip).name).to eq trip.name
        end
      end

    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create(:trip) }

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

        context 'and when trip is not private' do
          let(:trip) { FactoryGirl.create(:trip) }

          it 'renders show template' do
            get 'show', id: trip.id
            expect(response).to render_template 'trips/show'
            trip = assigns(:trip)
            expect(trip.id).to eq trip.id
            expect(trip.status_code).to eq Travels::Trip::StatusCodes::DRAFT
          end

          let(:filled_trip) { FactoryGirl.create(:trip, :with_filled_days, :with_caterings) }

          it 'renders docx' do
            get 'show', id: filled_trip.id, format: :docx
            expect(response).to have_http_status 200
            expect(response).to render_template 'trips/show'
            expect(assigns(:transfers_grid)).to eq TripsController::TRANSFERS_GRID
          end

        end

        context 'and when trip is private' do
          let(:trip) { FactoryGirl.create(:trip, private: true) }

          it 'redirects to dashboard with flash' do
            get 'show', id: trip.id
            expect(response).to redirect_to '/errors/no_access'
          end
        end

        context 'and when trip is private but current user is a participant' do
          let(:trip) { FactoryGirl.create(:trip, private: true, users: [subject.current_user]) }

          it 'renders show template' do
            get 'show', id: trip.id
            expect(response).to have_http_status 200
            expect(response).to render_template 'trips/show'
          end
        end

      end

      context 'and when trip does not exist' do
        it 'renders show template' do
          get 'show', id: 'non-existing-id'
          expect(response).to redirect_to '/errors/not_found'
        end
      end

    end

    context 'when no logged user' do
      context 'and when trip is not private' do
        let(:trip) { FactoryGirl.create(:trip) }

        it 'renders show template' do
          get 'show', id: trip.id
          expect(response).to have_http_status 200
          expect(response).to render_template 'trips/show'
        end
      end

      context 'and when trip is private' do
        let(:trip) { FactoryGirl.create(:trip, private: true) }

        it 'redirects to dashboard with flash' do
          get 'show', id: trip.id
          expect(response).to redirect_to '/errors/no_access'
        end
      end
    end
  end

  describe '#destroy' do
    context 'when user is logged in' do
      login_user

      context 'and when user is author' do
        let(:trip) { FactoryGirl.create(:trip, author_user: subject.current_user) }

        it 'marks trip as archived' do
          delete 'destroy', id: trip.id
          expect(Travels::Trip.where(id: trip.id).first).to be_nil
          expect(Travels::Trip.unscoped.where(id: trip.id, archived: true).first).not_to be_blank
          expect(response).to redirect_to trips_path(my: true)
        end

        it 'destroys all associated invites' do
          # create invite
          inviting_user = FactoryGirl.create(:user)
          Travels::TripInvite.create(inviting_user_id: inviting_user.id, invited_user_id: subject.current_user.id,
                                     trip_id: trip.id)

          expect(subject.current_user.incoming_invites.count).to eq(1)

          delete 'destroy', id: trip.id
          expect(Travels::Trip.where(id: trip.id).first).to be_nil

          expect(subject.current_user.incoming_invites.count).to eq(0)
        end
      end

      context 'and when user is just a participant' do
        let(:trip) { FactoryGirl.create(:trip, users: [subject.current_user]) }

        it 'redirects to dashboard with flash' do
          delete 'destroy', id: trip.id
          expect(response).to redirect_to '/errors/no_access'
        end
      end

      context 'and when trip does not exist' do
        it 'heads 404' do
          delete 'destroy', id: 'non existing'
          expect(response).to redirect_to '/errors/not_found'
        end
      end
    end

    context 'when no logged user' do
      let(:trip) { FactoryGirl.create(:trip) }

      it 'redirects to sign in' do
        delete 'destroy', id: trip.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#upload_photo' do
    login_user

    let(:trip) { FactoryGirl.create(:trip, author_user: subject.current_user, users: [subject.current_user]) }
    let(:file) { fixture_file_upload("#{::Rails.root}/spec/fixtures/files/cat.jpg", 'image/jpeg') }

    it 'uploads trip photo' do
      post 'upload_photo', id: trip.id, travels_trip: {image: file}, w: 10, h: 10, x: 10, y: 10, format: :js
      expect(response).to be_success
      expect(assigns(:trip).image).not_to be_blank
    end
  end

end