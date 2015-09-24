describe Api::UsersController do

  describe '#index' do
    before do
      User.destroy_all
      FactoryGirl.create_list(:user, 5, first_name: 'Sven', last_name: 'Petersson')
      FactoryGirl.create_list(:user, 8, first_name: 'Max', last_name: 'Mustermann')
      FactoryGirl.create_list(:user, 15)
    end

    def check_users body, term
      users = User.find_by_term(term).page(1).to_a
      json = JSON.parse(body)
      expect(json.first).to eq({"name" => users.first.full_name, "id" => users.first.id.to_s,
                                "photo_url" => users.first.image_url_or_default})
      expect(json.count).to eq users.count
    end

    context 'when user is logged in' do
      login_user
      after(:each){Rails.cache.clear}

      it 'responds with empty array if term is shorter than 2 letters' do
        get 'index', term: 'm', format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'responds with empty array if term is blank' do
        get 'index', format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'responds with users when something found by first name' do
        term = 'ma'
        get 'index', term: term, format: :json
        expect(response).to have_http_status 200
        check_users response.body, term
      end

      it 'responds with cities when something found by last name' do
        term = 'pet'
        get 'index', term: term, format: :json
        expect(response).to have_http_status 200
        check_users response.body, term
      end

      it 'responds with empty array if nothing found' do
        get 'index', term: 'ivan ivanov', format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end
    end

    context 'when no logged user' do
      it 'behaves the same as for logged user' do
        term = 'sve'
        get 'index', term: term, format: :json
        expect(response).to have_http_status 200
        check_users response.body, term
      end
    end
  end

end