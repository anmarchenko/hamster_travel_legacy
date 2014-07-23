describe Travels::Updaters::TripUpdater do

  def first_day_of tr
    tr.reload.days.first
  end

  def update_trip tr, prms
    Travels::Updaters::TripUpdater.new(tr, prms).process_days
  end

  let(:trip){FactoryGirl.create(:trip)}
  let(:day){first_day_of trip}


  before(:example) {update_trip trip, params}

  describe '#process_days' do
    context 'when params have non existing days' do
      let(:params) {{ '1' => {id: 'non_existing'} }}
      it 'does nothing' do
        expect(first_day_of(trip).hotel).not_to be_blank
      end
    end

    context 'when params have new hotel data' do
      let(:params) { {'1' => {id: day.id.to_s,
                              hotel: {
                                  name: 'new_name',
                                  comment: 'new_comment',
                                  price: 123,
                                  links: [{url: 'http://new.url', description: 'new_description'}]
                              }
      } } }

      it 'updates hotel attributes' do
        hotel = first_day_of(trip).hotel
        expect(hotel.name).to eq 'new_name'
        expect(hotel.comment).to eq 'new_comment'
        expect(hotel.price).to eq 123
        expect(hotel.links.count).to eq 1
        expect(hotel.links.first.url).to eq 'http://new.url'
        expect(hotel.links.first.description).to eq 'New.url'
      end

      it 'updates hotel link data' do
        hotel = first_day_of(trip).hotel
        params['1'][:hotel][:links] = [
            {
                id: hotel.links.first.id.to_s,
                url: 'http://updated.url'
            }
        ]
        update_trip trip, params

        updated_hotel = first_day_of(trip).hotel
        expect(updated_hotel.links.count).to eq 1
        expect(updated_hotel.links.first.id).to eq hotel.links.first.id
        expect(updated_hotel.links.first.url).to eq 'http://updated.url'
        expect(updated_hotel.links.first.description).to eq 'Updated.url'
      end

      it 'removes hotel link' do
        params['1'][:hotel].delete(:links)
        update_trip trip, params
        updated_hotel = first_day_of(trip).hotel
        expect(updated_hotel.links.count).to eq 0
      end
    end

    context 'when params have day attributes' do
      let(:params) { {'1' => {
                                id: day.id.to_s,
                                comment: 'new_day_comment',
                                add_price: 12345
                              }
                    }
      }

      it 'updates day data' do
        updated_day = first_day_of(trip)
        expect(updated_day.id).to eq day.id
        expect(updated_day.comment).to eq 'new_day_comment'
        expect(updated_day.add_price).to eq 12345
      end

      it 'updates day data even if day attributes are empty' do
        params['1'].delete :add_price
        update_trip trip, params
        updated_day = first_day_of trip
        expect(updated_day.id).to eq day.id
        expect(updated_day.comment).to eq 'new_day_comment'
        expect(updated_day.add_price).to be_nil
      end
    end


    context 'when params have places' do
      let(:params) { {'1' => {
                              id: day.id.to_s,
                              places: [
                                  {
                                      id: day.places.first.id.to_s,
                                      city_code: 'new_city_code_1',
                                      city_text: 'new_city_text_1'
                                  },
                                  {
                                      city_code: 'new_city_code_2',
                                      city_text: 'new_city_text_2'
                                  }
                              ]

          }
        }
      }

      it 'updates and creates new places' do
        updated_day = first_day_of trip
        expect(updated_day.places.count).to eq 2

        expect(updated_day.places.first.id).to eq day.places.first.id
        expect(updated_day.places.first.city_code).to eq 'new_city_code_1'
        expect(updated_day.places.first.city_text).to eq 'new_city_text_1'

        expect(updated_day.places.last.id).not_to eq day.places.first.id
        expect(updated_day.places.last.city_code).to eq 'new_city_code_2'
        expect(updated_day.places.last.city_text).to eq 'new_city_text_2'
      end

      it 'updates second place' do
        original_day = first_day_of trip
        params['1'][:places].first[:id] = original_day.places.first.id.to_s
        params['1'][:places].last[:id] = original_day.places.last.id.to_s
        params['1'][:places].last[:city_code] = 'new_city_code_3'
        update_trip trip, params

        updated_day = first_day_of trip
        expect(updated_day.places.count).to eq 2

        expect(updated_day.places.first.id).to eq original_day.places.first.id
        expect(updated_day.places.first.city_code).to eq 'new_city_code_1'
        expect(updated_day.places.first.city_text).to eq 'new_city_text_1'

        expect(updated_day.places.last.id).to eq original_day.places.last.id
        expect(updated_day.places.last.city_code).to eq 'new_city_code_3'
        expect(updated_day.places.last.city_text).to eq 'new_city_text_2'
      end

      it 'deletes places' do
        params['1'][:places].pop
        update_trip trip, params
        updated_day = first_day_of(trip)
        expect(updated_day.places.count).to eq 1
        expect(updated_day.places.first.id).to eq day.places.first.id
      end
    end

    context 'when params have transfers' do
      let(:params) { {'1' => {
                                id: day.id.to_s,
                                transfers: [
                                    {
                                        city_from_code: 'city_from_code_1',
                                        city_to_code: 'city_to_code_1',
                                        isCollapsed: true
                                    }
                                ]

                            }
                  }
              }

      it 'creates new transfers' do
        updated_day = first_day_of trip

        expect(updated_day.transfers.count).to eq 1

        expect(updated_day.transfers.first.city_from_code).to eq 'city_from_code_1'
        expect(updated_day.transfers.first.city_to_code).to eq 'city_to_code_1'
      end
    end


    context 'when has activities' do
      let(:params) { {'1' => {
                              id: day.id.to_s,
                              activities: [
                                  {
                                      name: 'name 1',
                                      isCollapsed: true
                                  },
                                  {
                                      name: 'name 2',
                                      isCollapsed: true
                                  },
                                  {
                                      name: 'name 3',
                                      isCollapsed: true
                                  }
                              ]

                          }
                    }
      }

      it 'creates new activities' do
        updated_day = first_day_of trip

        expect(updated_day.activities.count).to eq 3
        updated_day.activities.each_with_index do |act, index|
          expect(act.name).to eq "name #{index + 1}"
          expect(act.order_index).to eq index
        end

      end

      it 'reorders activities' do
        original_day = first_day_of trip

        old_activities = params['1'][:activities]
        old_activities.each_with_index do |act, index|
          act[:id] = original_day.activities[index].id.to_s
        end
        params['1'][:activities] = [old_activities[2], old_activities[0], old_activities[1]]
        update_trip trip, params

        updated_day = first_day_of trip
        expect(updated_day.activities.count).to eq 3
        updated_day.activities.each_with_index do |act, index|
          expect(act.name).to eq "name #{((index + 2) % 3) + 1 }"
          expect(act.order_index).to eq index
          expect(act.id).to eq original_day.activities[(index + 2) % 3].id
        end
      end

    end

  end
end