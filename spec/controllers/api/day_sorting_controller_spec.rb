# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::DaysSortingController do
  let(:user) { FactoryGirl.create(:user) }

  describe '#index' do
    before { login_user(user) }

    let(:trip) { FactoryGirl.create(:trip, users: [user]) }

    it 'returns short information about days as json' do
      get 'index', params: { trip_id: trip.id }, format: :json

      json_days = JSON.parse(response.body)
      expect(json_days.count).to eq(trip.days.ordered.count)
      expect(json_days.first['index']).to eq(trip.days.ordered.first.index)
    end
  end

  describe '#create' do
    before { login_user(user) }

    let(:trip) do
      FactoryGirl.create(
        :trip,
        start_date: Date.today,
        end_date: Date.today + 2.days,
        users: [user]
      )
    end
    let(:days) { Trips::Days.list(trip) }

    before do
      days_array = days.to_a

      (0..2).each do |day_index|
        (day_index + 1).times do |activity_index|
          days_array[day_index].activities.create(
            name: "Day #{day_index} Act #{activity_index}",
            order_index: activity_index
          )
        end

        days_array[day_index].transfers.create(
          city_from: FactoryGirl.create(:city),
          city_to: FactoryGirl.create(:city),
          comment: "Day #{day_index} transfer"
        )
        days_array[day_index].hotel = FactoryGirl.create(
          :hotel, name: "Day #{day_index} hotel"
        )
        days_array[day_index].places.first.update_attributes(
          city: FactoryGirl.create(:city, population: day_index)
        )

        days_array[day_index].update_attributes(
          comment: "Day #{day_index} comment"
        )
        days_array[day_index].expenses.first.update_attributes(
          amount_cents: day_index * 100,
          name: "Day #{day_index} expense"
        )
        days_array[day_index].links.create(
          url: "http://example#{day_index}.com"
        )
      end
    end

    let(:original_ids) { trip.days.ordered.pluck(:id) }

    let(:order_ids) do
      [original_ids[2], original_ids[0], original_ids[1]]
    end

    context 'reorder activities' do
      it 'reorders activities' do
        post 'create', params: {
          trip_id: trip.id,
          day_ids: order_ids,
          fields: ['activities']
        }, format: :json

        days_after = trip.reload.days.ordered.to_a

        expect(days_after[0].comment).to eq('Day 0 comment')
        expect(days_after[0].transfers.first.comment).to eq('Day 0 transfer')

        expect(days_after[0].id).to eq(original_ids[0])
        activities = Trips::Activities.list(days_after[0])
        expect(activities.count).to eq(3)
        expect(activities.first.name).to eq('Day 2 Act 0')
        expect(days_after[1].id).to eq(original_ids[1])
        activities = Trips::Activities.list(days_after[1])
        expect(activities.count).to eq(1)
        expect(activities.first.name).to eq('Day 0 Act 0')
        expect(days_after[2].id).to eq(original_ids[2])
        activities = Trips::Activities.list(days_after[2])
        expect(activities.count).to eq(2)
        expect(activities.first.name).to eq('Day 1 Act 0')
      end
    end

    context 'reorder transfers, hotels and places' do
      it 'reorders transfers, hotels and places' do
        post 'create', params: {
          trip_id: trip.id,
          day_ids: order_ids,
          fields: ['transfers']
        }, format: :json

        days_after = trip.reload.days.ordered.to_a
        expect(days_after[0].id).to eq(original_ids[0])
        expect(days_after[1].id).to eq(original_ids[1])
        expect(days_after[2].id).to eq(original_ids[2])

        activities = Trips::Activities.list(days_after[0])
        expect(activities.first.name).to eq('Day 0 Act 0')
        expect(days_after[0].comment).to eq('Day 0 comment')

        expect(days_after[0].transfers.first.comment).to eq('Day 2 transfer')
        expect(days_after[1].transfers.first.comment).to eq('Day 0 transfer')
        expect(days_after[2].transfers.first.comment).to eq('Day 1 transfer')

        expect(days_after[0].hotel.name).to eq('Day 2 hotel')
        expect(days_after[1].hotel.name).to eq('Day 0 hotel')
        expect(days_after[2].hotel.name).to eq('Day 1 hotel')

        expect(days_after[0].places.first.city.population).to eq(2)
        expect(days_after[1].places.first.city.population).to eq(0)
        expect(days_after[2].places.first.city.population).to eq(1)
      end
    end

    context 'reorder other info' do
      it 'reorders other info' do
        post 'create', params: {
          trip_id: trip.id,
          day_ids: order_ids,
          fields: ['day_info']
        }, format: :json

        days_after = trip.reload.days.ordered.to_a

        activities = Trips::Activities.list(days_after[0])
        expect(activities.first.name).to eq('Day 0 Act 0')
        expect(days_after[0].transfers.first.comment).to eq('Day 0 transfer')

        expect(days_after[0].comment).to eq('Day 2 comment')
        expect(days_after[1].comment).to eq('Day 0 comment')
        expect(days_after[2].comment).to eq('Day 1 comment')
        expect(days_after[0].expenses.first.amount_cents).to eq(200)
        expect(days_after[1].expenses.first.amount_cents).to eq(0)
        expect(days_after[2].expenses.first.amount_cents).to eq(100)
        expect(days_after[0].links.first.url).to eq('http://example2.com')
        expect(days_after[1].links.first.url).to eq('http://example0.com')
        expect(days_after[2].links.first.url).to eq('http://example1.com')
      end
    end

    context 'reorder all' do
      it 'reorders all' do
        post 'create', params: {
          trip_id: trip.id,
          day_ids: order_ids,
          fields: %w[day_info activities transfers]
        }, format: :json

        days_after = trip.reload.days.ordered.to_a
        expect(days_after[0].comment).to eq('Day 2 comment')
        expect(days_after[1].comment).to eq('Day 0 comment')
        expect(days_after[2].comment).to eq('Day 1 comment')
        expect(Trips::Activities.list(days_after[0]).first.name).to eq(
          'Day 2 Act 0'
        )
        expect(Trips::Activities.list(days_after[1]).first.name).to eq(
          'Day 0 Act 0'
        )
        expect(Trips::Activities.list(days_after[2]).first.name).to eq(
          'Day 1 Act 0'
        )
        expect(days_after[0].transfers.first.comment).to eq('Day 2 transfer')
        expect(days_after[1].transfers.first.comment).to eq('Day 0 transfer')
        expect(days_after[2].transfers.first.comment).to eq('Day 1 transfer')
      end
    end
  end
end
