describe Updaters::DayPlaces do
  def first_day_of tr
    tr.reload.days.first
  end

  let(:trip) { FactoryGirl.create(:trip) }
  let(:day) { first_day_of trip }

  describe '#process' do
    context 'when params have places' do
      let(:params) {
        [
              {
                  id: day.places.first.id.to_s,
                  city_id: Geo::City.all.first.id
              }.with_indifferent_access,
              {
                  city_id: Geo::City.all.last.id
              }.with_indifferent_access
          ]

      }

      it 'updates and creates new places' do
        Updaters::DayPlaces.new(day, params).process
        updated_day = first_day_of trip
        expect(updated_day.places.count).to eq 2

        expect(updated_day.places.first.id).to eq day.places.first.id
        expect(updated_day.places.first.city_id).to eq Geo::City.all.first.id
        expect(updated_day.places.first.city_text).to eq Geo::City.all.first.translated_name

        expect(updated_day.places.last.id).not_to eq day.places.first.id
        expect(updated_day.places.last.city_id).to eq Geo::City.all.last.id
        expect(updated_day.places.last.city_text).to eq Geo::City.all.last.translated_name

        expect(updated_day.trip.countries_search_index.include?(Geo::City.all.first.country.translated_name(:en))).to be true
        expect(updated_day.trip.countries_search_index.include?(Geo::City.all.last.country.translated_name(:en))).to be true
      end

      it 'updates second place' do
        Updaters::DayPlaces.new(day, params).process
        original_day = first_day_of trip
        params.first[:id] = original_day.places.first.id.to_s
        params.last[:id] = original_day.places.last.id.to_s
        params.last[:city_id] = Geo::City.all.to_a[1].id

        Updaters::DayPlaces.new(day, params).process

        updated_day = first_day_of trip
        expect(updated_day.places.count).to eq 2

        expect(updated_day.places.first.id).to eq original_day.places.first.id
        expect(updated_day.places.first.city_id).to eq Geo::City.all.to_a[0].id
        expect(updated_day.places.first.city_text).to eq Geo::City.all.to_a[0].translated_name

        expect(updated_day.places.last.id).to eq original_day.places.last.id
        expect(updated_day.places.last.city_id).to eq Geo::City.all.to_a[1].id
        expect(updated_day.places.last.city_text).to eq Geo::City.all.to_a[1].translated_name
      end

      it 'deletes places' do
        local_trip = trip
        Updaters::DayPlaces.new(day, params).process
        params.pop
        updated_day = first_day_of(local_trip)
        Updaters::DayPlaces.new(updated_day, params).process
        updated_day = first_day_of(local_trip)
        expect(updated_day.places.count).to eq 1
      end
    end
  end
end