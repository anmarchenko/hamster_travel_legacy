# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Updaters::Caterings do
  def update_trip_caterings(tr, prms)
    ::Updaters::Caterings.new(tr, prms).process
  end

  describe '#process' do
    before(:example) { update_trip_caterings trip, params }
    let(:trip) { FactoryGirl.create(:trip) }

    context 'when there are caterings params' do
      let(:params) do
        [
          {
            name: Faker::Address.city,

            description: Faker::Lorem.paragraph,
            amount_cents: (rand(10_000) * 100),
            amount_currency: 'RUB',

            days_count: 3,
            persons_count: 2

          }.with_indifferent_access,
          {
            name: Faker::Address.city,

            description: Faker::Lorem.paragraph,
            amount_cents: (rand(10_000) * 100),
            amount_currency: 'RUB',

            days_count: 3,
            persons_count: 2
          }.with_indifferent_access
        ]
      end

      it 'creates new caterings' do
        caterings = trip.reload.caterings
        expect(caterings.count).to eq(2)
        expect(caterings.first.trip_id).to eq(trip.id)
        expect(caterings.first.name).not_to be_blank
      end

      it 'updates caterings' do
        id = trip.reload.caterings.first.id
        params.first['id'] = id
        params.first['name'] = 'Paris'

        update_trip_caterings trip, params

        caterings = trip.reload.caterings
        expect(caterings.count).to eq(2)
        expect(caterings.where(id: id).first.name).to eq('Paris')
      end

      it 'deletes caterings' do
        params.pop

        update_trip_caterings trip, params

        caterings = trip.reload.caterings
        expect(caterings.count).to eq(1)
      end
    end
  end
end
