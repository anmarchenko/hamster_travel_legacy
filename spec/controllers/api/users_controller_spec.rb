describe Api::UsersController do
  let(:user) { FactoryGirl.create(:user) }

  before { FactoryGirl.create_list(:trip, 2, user_ids: [user.id]) }
  before { FactoryGirl.create_list(:trip, 3,
                                   user_ids: [user.id],
                                   status_code: Travels::Trip::StatusCodes::PLANNED ) }
  before { FactoryGirl.create_list(:trip, 4,
                                   user_ids: [user.id],
                                   status_code: Travels::Trip::StatusCodes::PLANNED,
                                   archived: true) }
  before { FactoryGirl.create_list(:trip, 1,
                                   user_ids: [user.id],
                                   status_code: Travels::Trip::StatusCodes::PLANNED,
                                   private: true) }
  before { FactoryGirl.create_list(:trip, 13, :with_filled_days, user_ids: [user.id], status_code: Travels::Trip::StatusCodes::FINISHED) }
  before { FactoryGirl.create_list(:trip, 3, :with_filled_days, user_ids: [user.id], status_code: Travels::Trip::StatusCodes::FINISHED,
                                   archived: true) }

  describe '#index' do
    before do
      User.destroy_all
      FactoryGirl.create_list(:user, 5, first_name: 'Sven', last_name: 'Petersson')
      FactoryGirl.create_list(:user, 8, first_name: 'Max', last_name: 'Mustermann')
      FactoryGirl.create_list(:user, 15)
    end

    def check_users(body, term)
      users = User.find_by_term(term).page(1).to_a
      json = JSON.parse(body)
      expect(json.first).to eq({"name" => users.first.full_name, "code" => users.first.id.to_s,
                                "photo_url" => users.first.image_url, "text" => users.first.full_name,
                                "initials" => users.first.initials, "color" => users.first.background_color})
      expect(json.count).to eq users.count
    end

    context 'when user is logged in' do
      login_user

      after(:each) { Rails.cache.clear }

      it 'responds with empty array if term is shorter than 2 letters' do
        get 'index', params: {term: 'm'}, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'does not find logged user' do
        get 'index', params: {term: 'first'}, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body).count).to eq 15
      end

      it 'responds with empty array if term is blank' do
        get 'index', format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'responds with users when something found by first name' do
        term = 'ma'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        check_users response.body, term
      end

      it 'responds with users when something found by last name' do
        term = 'pet'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        check_users response.body, term
      end

      it 'responds with users when something found by last name and first name' do
        term = 'sven pet'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json.count).to eq 5
      end

      it 'finds several parts together always' do
        term = 'sven m'
        get 'index', params: {term: term}, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'finds several parts together' do
        term = 'sven mu'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'responds with empty array if nothing found' do
        get 'index', params: { term: 'ivan ivanov' }, format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end
    end

    context 'when no logged user' do
      it 'behaves the same as for logged user' do
        term = 'sve'
        get 'index', params: { term: term }, format: :json
        expect(response).to have_http_status 200
        check_users response.body, term
      end
    end
  end

  describe '#show' do
    context 'when user is logged in' do
      login_user

      it 'returns user with information about trips, countries and cities' do
        get 'show', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['user']).not_to be_blank
        user_json = json['user']
        expect(user_json['email']).to be_blank
        expect(user_json['id'].to_s).to eq(user.id.to_s)
        expect(user_json['color']).to eq(user.background_color)
        expect(user_json['initials']).to eq(user.initials)
        expect(user_json['home_town_text']).to eq(user.home_town_text)

        expect(user_json['finished_trips_count']).to eq(13)
        expect(user_json['visited_cities_count']).to eq(1)
        expect(user_json['visited_countries_count']).to eq(1)
      end
    end

    context 'when no logged user' do
      it 'returns same information' do
        get 'show', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['user']).not_to be_blank
        user_json = json['user']
        expect(user_json['email']).to be_blank
        expect(user_json['id'].to_s).to eq(user.id.to_s)
      end
    end
  end

  describe '#visited' do
    context 'when user is logged in' do
      login_user

      it 'returns list of countries and cities that user visited' do
        get 'visited', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['countries']).not_to be_blank
        expect(json['countries'].count).to eq(1)
        expect(json['cities']).not_to be_blank
        expect(json['cities'].count).to eq(1)
      end
    end
  end

  describe '#finished_trips' do
    context 'when user is logged in' do
      login_user

      it "returns list of the user's finished trips paginated" do
        get 'finished_trips', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['trips'].count).to eq(9)
      end
    end

    context 'when no logged user' do
      it "returns list of the user's finished trips paginated" do
        get 'finished_trips', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['trips'].count).to eq(9)
      end
    end
  end

  describe '#planned_trips' do
    context 'when user is logged in' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
      end

      it "returns list of the user's planned trips including private" do
        get 'planned_trips', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['trips'].count).to eq(4)
      end
    end

    context 'when no logged user' do
      it "returns list of the user's planned trips excluding private" do
        get 'planned_trips', params: { id: user.id }
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body)
        expect(json['trips'].count).to eq(3)
      end
    end
  end
end
