describe TripsController do

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

end