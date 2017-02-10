# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Api::DaysSortingController do
  describe '#index' do
    before { login_user(user) }

    let(:trip) { FactoryGirl.create(:trip, users: [subject.current_user]) }

    it 'returns short information about days as json' do
      get 'index', params: { trip_id: trip.id }, format: :json

      json_days = JSON.parse(response.body)
      expect(json_days.count).to eq(trip.days.count)
      expect(json_days.first['index']).to eq(trip.days.first.index)
    end
  end

  describe '#create' do
    before { login_user(user) }

    let!(:trip) { FactoryGirl.create(:trip, :with_filled_days, users: [subject.current_user]) }

    it 'reorders days' do
      ids = trip.days.map(&:id)
      temp = ids[0]
      ids[0] = ids[-1]
      ids[-1] = temp

      post 'create', params: { trip_id: trip.id, day_ids: ids }, format: :json

      days_after = trip.reload.days
      expect(days_after.first.id).to eq(ids.first)
      expect(days_after.last.id).to eq(ids.last)
    end
  end
end
