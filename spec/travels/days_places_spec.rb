# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Trips::Days do
  def first_day_of(tr)
    tr.reload.days.ordered.first
  end

  let(:trip) { FactoryGirl.create(:trip) }
  let(:day) { first_day_of trip }

  describe '#process' do
    let(:city1) { FactoryGirl.create(:city) }
    let(:city2) { FactoryGirl.create(:city) }
    let(:city3) { FactoryGirl.create(:city) }

    context 'when params have places' do
      let(:params) do
        [
          {
            id: day.places.first.id.to_s,
            city_id: city1.id
          }.with_indifferent_access,
          {
            city_id: city2.id
          }.with_indifferent_access
        ]
      end

      it 'updates and creates new places' do
        Trips::Days.save_places(day, places: params)
        updated_day = first_day_of trip
        expect(updated_day.places.count).to eq 2

        expect(updated_day.places.first.id).to eq day.places.first.id
        expect(updated_day.places.first.city_id).to eq city1.id
        expect(updated_day.places.first.city_text).to eq city1.translated_name

        expect(updated_day.places.last.id).not_to eq day.places.first.id
        expect(updated_day.places.last.city_id).to eq city2.id
        expect(updated_day.places.last.city_text).to eq city2.translated_name

        search_index = updated_day.trip.countries_search_index
        expect(search_index.include?(city1.country.translated_name(:en))).to(
          be(true)
        )
        expect(search_index.include?(city2.country.translated_name(:en))).to(
          be(true)
        )
      end

      it 'updates second place' do
        Trips::Days.save_places(day, places: params)
        original_day = first_day_of trip
        params.first[:id] = original_day.places.first.id.to_s
        params.last[:id] = original_day.places.last.id.to_s
        params.last[:city_id] = city3.id

        Trips::Days.save_places(day, places: params)

        updated_day = first_day_of trip
        expect(updated_day.places.count).to eq 2

        expect(updated_day.places.first.id).to eq original_day.places.first.id
        expect(updated_day.places.first.city_id).to eq city1.id
        expect(updated_day.places.first.city_text).to eq city1.translated_name

        expect(updated_day.places.last.id).to eq original_day.places.last.id
        expect(updated_day.places.last.city_id).to eq city3.id
        expect(updated_day.places.last.city_text).to eq city3.translated_name
      end

      it 'deletes places' do
        local_trip = trip
        Trips::Days.save_places(day, places: params)
        params.pop
        updated_day = first_day_of(local_trip)
        Trips::Days.save_places(updated_day, places: params)
        updated_day = first_day_of(local_trip)
        expect(updated_day.places.count).to eq 1
      end
    end
  end
end
