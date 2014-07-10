describe TripsController do

  describe '#index' do

    context 'when user is logged in' do
      login_user

      before {FactoryGirl.create_list(:trip, 6, user_ids: [subject.current_user.id])}
      before {FactoryGirl.create_list(:trip, 12)}
      after {expect(response).to render_template 'trips/index'}

      it 'shows trips index page' do
        get 'index'
        trips = assigns(:trips)
        expect(trips.to_a.count).to eq 9
      end

      it 'shows user\'s trip when parameter \'my\' is present' do
        get 'index', my: true
        trips = assigns(:trips)
        expect(trips.to_a.count).to eq 6
        trips.each do |trip|
          expect(trip.include_user(subject.current_user)).to be true
        end
      end

    end

    context 'when no logged user' do

    end
  end

end