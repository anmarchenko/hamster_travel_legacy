describe DashboardController do

  context 'when there are some trips' do
    before { FactoryGirl.create_list(:trip, 6) }
    before { FactoryGirl.create_list(:trip, 2, private: true) }

    it 'should get index and retrieve first 3 trips' do
      get 'index'
      expect(response).to be_success
      expect(response).to render_template('dashboard/index')
      trips = assigns(:trips).to_a
      expect(trips.count).to eq 3
      trips.each_index do |i|
        expect(trips[i].private).to eq false
        next if trips[i+1].blank?
        expect(trips[i].created_at).to be >= (trips[i+1].created_at)
      end
    end
  end

  context 'when there are no trips' do
    before {Travels::Trip.destroy_all}
    it 'should get index and retrieve first 3 trips' do
      get 'index'
      expect(response).to be_success
      expect(response).to render_template('dashboard/index')
      expect(assigns(:trips).to_a.count).to eq 0
    end
  end

end