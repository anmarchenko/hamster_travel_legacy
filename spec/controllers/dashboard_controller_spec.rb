describe DashboardController do

  context 'when there are some trips' do
    before { FactoryGirl.create_list(:trip, 6) }
    it 'should get index and retrieve first 3 trips' do
      get 'index'
      expect(response).to be_success
      expect(response).to render_template('dashboard/index')
      trips = assigns(:trips).to_a
      expect(trips.count).to eq 3
      [0, 1].each do |i|
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