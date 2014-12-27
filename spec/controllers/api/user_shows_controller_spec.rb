describe Api::UserShowsController do
  describe '#show' do
    let(:trip_without_user) {FactoryGirl.create :trip}
    let(:trip) {FactoryGirl.create :trip, users: [subject.current_user]}

    context 'when user is logged in' do
      login_user
      let(:old_user_id){subject.current_user.id.to_s}

      context 'and when there is trip' do
        context 'and when input params are valid' do
          it 'sets user as watching a trip and returning an empty list of watching users' do
            get 'show', id: trip.id.to_s, format: :json
            expect(response).to have_http_status 200
            json = JSON.parse(response.body)
            expect(json).to eq(JSON.parse('[]'))

            # check that redis have information about user
            expect($redis.zrange(trip.id.to_s, 0, -1)).to eq([subject.current_user.id.to_s])
          end

          context 'and when another user watching a trip' do

            it 'should return list containing one user name NOW and empty list after 10 SECONDS' do
              user = FactoryGirl.create(:user)
              trip.users << subject.current_user
              trip.save

              $redis.zadd(trip.id.to_s, Time.now.to_i, user.id)

              get 'show', id: trip.id.to_s, format: :json

              expect(response).to have_http_status 200
              json = JSON.parse(response.body)
              expect(json[0]).to eq(user.full_name)

              # 10 seconds after...
              Timecop.travel(Time.now + 10.seconds)

              get 'show', id: trip.id.to_s, format: :json

              expect(response).to have_http_status 200
              json = JSON.parse(response.body)
              expect(json).to eq(JSON.parse('[]'))
            end
          end
        end

        context 'and when user is not included in trip' do
          it 'heads 403' do
            get 'show', id: trip_without_user.id.to_s, format: :json
            expect(response).to have_http_status 403
          end
        end
      end

      context 'and when there is no trip' do
        it 'heads 404' do
          get 'show', id: 'no_trip', format: :json
          expect(response).to have_http_status 404
        end
      end

    end

    context 'when no logged user' do
      it 'redirects to sign in' do
        get 'show', id: trip.id.to_s, format: :json
        expect(response).to have_http_status 401
      end
    end
  end

end