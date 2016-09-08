describe HomePageController do
  describe '#index' do
    it 'should render page' do
      get 'index'
      expect(response).to be_success
      expect(response).to render_template('home_page/index')
    end
  end
end
