describe DashboardController do

  context 'when there are some trips' do
    before { FactoryGirl.create_list(:trip, 6) }
    before { FactoryGirl.create_list(:trip, 2, private: true) }

    it 'should get index and retrieve first 3 trips' do
      get 'index'
      expect(response).to be_success
      expect(response).to render_template('dashboard/index')
    end
  end

end