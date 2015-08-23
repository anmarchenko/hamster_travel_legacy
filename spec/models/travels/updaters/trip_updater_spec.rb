describe Travels::Updaters::TripUpdater do

  def first_day_of tr
    tr.reload.days.first
  end

  def update_trip_days tr, prms
    Travels::Updaters::TripUpdater.new(tr, prms).process_days
  end

  def update_trip_caterings tr, prms
    Travels::Updaters::TripUpdater.new(tr, prms).process_caterings
  end

  def update_trip tr, prms
    Travels::Updaters::TripUpdater.new(tr, prms).process_trip
  end

  let(:trip) { FactoryGirl.create(:trip) }
  let(:day) { first_day_of trip }

  describe '#process_caterings' do
    before(:example) { update_trip_caterings trip, params }

    context 'when there are caterings params' do

      let(:params) { {
          '1' => FactoryGirl.build(:catering).as_json.merge(id: Time.now.to_i),
          '2' => FactoryGirl.build(:catering).as_json.merge(id: Time.now.to_i)
      } }
      it 'creates new caterings' do
        caterings = trip.reload.caterings
        expect(caterings.count).to eq(2)
        expect(caterings.first.trip_id).to eq(trip.id)
        expect(caterings.first.name).not_to be_blank
      end

      it 'updates caterings' do
        params['1']['id'] = trip.caterings.first.id
        params['1']['name'] = 'Paris'

        update_trip_caterings trip, params

        caterings = trip.reload.caterings
        expect(caterings.count).to eq(2)
        expect(caterings.where(id: params['1']['id']).first.name).to eq('Paris')
      end

      it 'deletes caterings' do
        params.delete('2')

        update_trip_caterings trip, params

        caterings = trip.reload.caterings
        expect(caterings.count).to eq(1)
      end
    end
  end

  describe '#process_days' do

    before(:example) { update_trip_days trip, params }

    context 'when params have non existing days' do
      let(:params) { {'1' => {id: 'non_existing'}} }
      it 'does nothing' do
        expect(first_day_of(trip).hotel).not_to be_blank
      end
    end

    context 'when params have new hotel data' do

      let(:params) { {'1' => {id: day.id.to_s,
                              hotel: {
                                  name: 'new_name',
                                  comment: 'new_comment',
                                  amount_cents: 123,
                                  amount_currency: 'EUR',
                                  links: [{url: 'http://new.url', description: 'new_description'}]
                              }.with_indifferent_access
      }} }

      it 'updates hotel attributes' do
        hotel = first_day_of(trip).hotel
        expect(hotel.name).to eq 'new_name'
        expect(hotel.comment).to eq 'new_comment'
        expect(hotel.amount).to eq Money.new(12300, 'EUR')
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
        update_trip_days trip, params

        updated_hotel = first_day_of(trip).hotel
        expect(updated_hotel.links.count).to eq 1
        expect(updated_hotel.links.first.id).to eq hotel.links.first.id
        expect(updated_hotel.links.first.url).to eq 'http://updated.url'
        expect(updated_hotel.links.first.description).to eq 'Updated.url'
      end

      it 'removes hotel name and price' do
        params['1'][:hotel][:name] = ''
        params['1'][:hotel][:amount_cents] = ''
        params['1'][:hotel][:comment] = ''

        update_trip_days trip, params

        updated_hotel = first_day_of(trip).hotel
        expect(updated_hotel.name).to be_blank
        expect(updated_hotel.amount_cents).to eq(0)
        expect(updated_hotel.comment).to be_blank
      end

      it 'removes hotel link' do
        params['1'][:hotel].delete(:links)
        update_trip_days trip, params
        updated_hotel = first_day_of(trip).hotel
        expect(updated_hotel.links.count).to eq 0
      end
    end

    context 'when params have day attributes' do
      let(:params) {
        {
            '1' => {
                id: day.id.to_s,
                comment: 'new_day_comment'
            }
        }
      }

      it 'updates day data' do
        updated_day = first_day_of(trip)
        expect(updated_day.id).to eq day.id
        expect(updated_day.comment).to eq 'new_day_comment'
      end

      it 'updates day data even if day attributes are empty' do
        params['1'].delete :comment
        update_trip_days trip, params
        updated_day = first_day_of trip
        expect(updated_day.id).to eq day.id
        expect(updated_day.comment).to eq nil
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
              }.with_indifferent_access,
              {
                  city_code: 'new_city_code_2',
                  city_text: 'new_city_text_2'
              }.with_indifferent_access
          ]

      }.with_indifferent_access
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
        update_trip_days trip, params

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
        update_trip_days trip, params
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
              }.with_indifferent_access,
              {
                  city_from_code: 'city_from_code_2',
                  city_to_code: 'city_to_code_2',
                  isCollapsed: false
              }.with_indifferent_access,
              {
                  city_from_code: 'city_from_code_3',
                  city_to_code: 'city_to_code_3',
                  isCollapsed: false
              }.with_indifferent_access,
              {
                  city_from_code: 'city_from_code_4',
                  city_to_code: 'city_to_code_4',
                  isCollapsed: false
              }.with_indifferent_access
          ]

      }.with_indifferent_access
      }
      }

      it 'creates new transfers' do
        updated_day = first_day_of trip

        expect(updated_day.transfers.count).to eq 4

        expect(updated_day.transfers.first.city_from_code).to eq 'city_from_code_1'
        expect(updated_day.transfers.first.city_to_code).to eq 'city_to_code_1'
      end

      it 'reorders transfers' do
        original_day = first_day_of trip

        old_transfers = params['1'][:transfers]
        old_transfers.each_with_index do |tr, index|
          tr[:id] = original_day.transfers[index].id.to_s
        end
        permutation = {0 => 3, 1 => 1, 2 => 0, 3 => 2}
        params['1'][:transfers] = [old_transfers[3], old_transfers[1], old_transfers[0], old_transfers[2]]
        update_trip_days trip, params

        updated_day = first_day_of trip
        expect(updated_day.transfers.count).to eq 4
        updated_day.transfers.each_with_index do |tr, index|
          expect(tr.city_from_code).to eq "city_from_code_#{permutation[index] + 1}"
          expect(tr.city_to_code).to eq "city_to_code_#{permutation[index] + 1}"
          expect(tr.order_index).to eq index
          expect(tr.id).to eq original_day.transfers[permutation[index]].id
        end

      end
    end


    context 'when has activities' do
      let(:params) { {'1' => {
          id: day.id.to_s,
          activities: [
              {
                  name: 'name 1',
                  isCollapsed: true
              }.with_indifferent_access,
              {
                  name: 'name 2',
                  isCollapsed: true
              }.with_indifferent_access,
              {
                  name: 'name 3',
                  isCollapsed: true
              }.with_indifferent_access,
              {
                  name: '',
                  isCollapsed: true,
                  comment: 'some comment'
              }.with_indifferent_access
          ]

      }
      }
      }

      it 'creates new activities skipping activity without name' do
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
        update_trip_days trip, params

        updated_day = first_day_of trip
        expect(updated_day.activities.count).to eq 3
        updated_day.activities.each_with_index do |act, index|
          expect(act.name).to eq "name #{((index + 2) % 3) + 1 }"
          expect(act.order_index).to eq index
          expect(act.id).to eq original_day.activities[(index + 2) % 3].id
        end
      end

    end

    context 'when params have day expenses data' do

      let(:params) { {'1' => {id: day.id.to_s,
                              expenses: [{
                                             name: 'new_expense_name',
                                             amount_cents: 456,
                                             amount_currency: 'RUB',
                                             amount_currency_text: 'R'
                                         }.with_indifferent_access,
                                         {
                                             name: 'new_expense_name_2',
                                             amount_cents: 98765,
                                             amount_currency: 'RUB',
                                             amount_currency_text: 'R'
                                         }.with_indifferent_access
                              ]
      }} }

      it 'updates expenses attributes' do
        expenses = first_day_of(trip).expenses
        expect(expenses.count).to eq 2
        expect(expenses.first.name).to eq 'new_expense_name'
        expect(expenses.first.amount.to_f).to eq 456.0
        expect(expenses.last.name).to eq 'new_expense_name_2'
        expect(expenses.last.amount.to_f).to eq 98765.0
      end

      it 'updates expense and removes' do
        expenses = first_day_of(trip).expenses
        params['1'][:expenses] = [
            {
                id: expenses.first.id.to_s,
                name: 'updated_name',
                amount_currency: 'EUR'
            }.with_indifferent_access
        ]
        update_trip_days trip, params

        updated_expenses = first_day_of(trip).expenses
        expect(updated_expenses.count).to eq 1
        expect(updated_expenses.first.reload.name).to eq 'updated_name'
        expect(updated_expenses.first.reload.amount).to eq(Money.new(45600, 'EUR'))
      end

      it 'updates expense when amount is empty' do
        expenses = first_day_of(trip).expenses
        params['1'][:expenses] = [
            {
                id: expenses.first.id.to_s,
                name: '',
                amount_cents: '',
                amount_currency: 'EUR'
            }.with_indifferent_access
        ]
        update_trip_days trip, params

        updated_expenses = first_day_of(trip).expenses
        expect(updated_expenses.count).to eq 1
        expect(updated_expenses.first.reload.name).to eq ''
        expect(updated_expenses.first.reload.amount).to eq(Money.new(0, 'EUR'))
      end

      it 'removes expenses' do
        params['1'].delete(:expenses)
        update_trip_days trip, params
        updated_day = first_day_of(trip)
        expect(updated_day.expenses.count).to eq 1 # default one
      end
    end

  end

  describe '#process_trip' do
    let(:params) { {comment: 'New comment!!!', short_description: 'super short short desc', budget_for: 2} }
    before(:example) { update_trip trip, params }

    it 'updates comment field' do
      updated_trip = trip.reload
      expect(updated_trip.comment).to eq('New comment!!!')
      expect(updated_trip.budget_for).to eq(2)
      expect(updated_trip.short_description).to eq('short_description')
    end
  end

end