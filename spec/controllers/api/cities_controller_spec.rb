describe Api::CitiesController do

  describe '#index' do
    context 'when user is logged in' do
      login_user

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
        get 'index', term: 'city 1', format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json.first).to eq({"name" => "Город 11", "text"=>"Город 11, Регион 6, Страна 5", "code"=>"11"})
        expect(json.count).to eq 6
      end

      it 'responds with cities when something found by russian name' do
        get 'index', term: 'город 1', format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json.first).to eq({"name" => "Город 11", "text"=>"Город 11, Регион 6, Страна 5", "code"=>"11"})
        expect(json.count).to eq 6
      end

      it 'responds with empty array if nothing found' do
        get 'index', term: 'capital', format: :json
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)).to eq []
      end
    end

    context 'when no logged user' do
      it 'behaves the same as for logged user' do
        get 'index', term: 'city 1', format: :json
        expect(response).to have_http_status 200
        json = JSON.parse(response.body)
        expect(json.first).to eq({"name" => "Город 11", "text"=>"Город 11, Регион 6, Страна 5", "code"=>"11"})
        expect(json.count).to eq 6
      end
    end
  end

end