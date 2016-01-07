describe Api::CitiesController do

  describe '#index' do
    def check_cities body, term
      cities = Geo::City.find_by_term(term).page(1).to_a
      json = JSON.parse(body)
      expect(json.first).to eq({"name" => cities.first.name, "text" => cities.first.translated_text,
                                "code" => cities.first.id, 'flag_image' => ApplicationController.helpers.flag(cities.first.country_code)})
      expect(json.count).to eq cities.count
    end

    context 'when user is logged in' do
      login_user
      after(:each){Rails.cache.clear}

      it 'responds with empty array if term is shorter than 3 letters' do
        get 'index', term: 'ci', format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'responds with empty array if term is blank' do
        get 'index', format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end

      it 'responds with cities when something found by english name' do
        term = 'city'
        get 'index', term: term, format: :json
        expect(response).to have_http_status 200
        check_cities response.body, term
      end

      it 'responds with cities when something found by russian name' do
        term = 'город'
        get 'index', term: term, format: :json
        expect(response).to have_http_status 200
        check_cities response.body, term
      end

      it 'responds with empty array if nothing found' do
        get 'index', term: 'capital', format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end
    end

    context 'when no logged user' do
      it 'behaves the same as for logged user' do
        term = 'city'
        get 'index', term: term, format: :json
        expect(response).to have_http_status 200
        check_cities response.body, term
      end
    end
  end

end