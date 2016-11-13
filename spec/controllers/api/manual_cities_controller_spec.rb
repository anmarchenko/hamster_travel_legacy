describe Api::ManualCitiesController do
  describe '#index' do
    login_user

    context 'when user is trying to acess his own data' do
      context 'when no manual cities' do
        it 'returns empty list' do
          get 'index', params: { user_id: subject.current_user.id }

          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['manual_cities'].count).to eq(0)
        end
      end

      context 'when there are manual cities' do
        let(:city1) { Geo::City.all.order(id: :asc).first }
        let(:city2) { Geo::City.all.order(id: :asc).last }
        let(:city_ids) { [city1.id, city2.id].sort }
        before do
          subject.current_user.manual_cities << city1
          subject.current_user.manual_cities << city2
          subject.current_user.save
        end

        it 'returns list of the cities in JSON' do
          get 'index', params: { user_id: subject.current_user.id }

          expect(response).to have_http_status 200
          json = JSON.parse(response.body)
          expect(json['manual_cities'].count).to eq(2)
          expect([json['manual_cities'].first['id'], json['manual_cities'].last['id']].sort).to eq(city_ids)
        end
      end
    end

    context 'when user is trying to access another user\'s data' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        user.manual_cities << Geo::City.all.first
        user.save
      end

      it 'returns 403 error' do
        get 'index', params: { user_id: user.id }
        expect(response).to have_http_status 403
      end
    end
  end

  describe '#create' do
    login_user

    let(:city1) { Geo::City.all.order(id: :asc).first }
    let(:city2) { Geo::City.all.order(id: :asc).last }
    let(:manual_cities_ids) { [city1.id, city2.id] }
    let(:manual_cities_ids_short) { [city2.id] }

    context 'when user is trying to acess his own data' do
      context 'when list is initially empty' do
        it 'adds data' do
          post 'create', params: { user_id: subject.current_user.id, manual_cities_ids: manual_cities_ids }
          expect(response).to have_http_status 200
          expect(subject.current_user.reload.manual_cities.count).to eq(2)
        end
      end

      context 'when list is initially full' do
        before do
          subject.current_user.manual_cities << city1
          subject.current_user.manual_cities << city2
          subject.current_user.save
        end

        it 'adds and deletes data' do
          expect(subject.current_user.reload.manual_cities.count).to eq(2)
          post 'create', params: { user_id: subject.current_user.id, manual_cities_ids: manual_cities_ids_short }
          expect(response).to have_http_status 200
          expect(subject.current_user.reload.manual_cities.count).to eq(1)
        end
      end
    end

    context 'when user is trying to access another user\'s data' do
      let(:user) { FactoryGirl.create(:user) }

      it 'returns 403 error' do
        post 'create', params: { user_id: user.id, manual_cities_ids: manual_cities_ids }
        expect(response).to have_http_status 403
        expect(user.reload.manual_cities).to be_blank
      end
    end
  end
end
