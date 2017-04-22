# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserTrips do
  describe '.list_trips' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(
        :trip,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::FINISHED,
        private: true
      )
      FactoryGirl.create(
        :trip,
        user_ids: [user.id]
      )
      FactoryGirl.create(
        :trip,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::PLANNED
      )
      FactoryGirl.create(
        :trip,
        status_code: Trips::StatusCodes::FINISHED
      )
    end

    it 'returns user trips without drafts ordered only by start_date' do
      trips = ::UserTrips.list_user_trips(user, 1)
      expect(trips.count).to eq 2
    end
  end

  describe '.list_drafts' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create_list(:trip, 2, user_ids: [user.id])
      FactoryGirl.create(:trip, :no_dates, user_ids: [user.id])
      FactoryGirl.create(:trip)
      FactoryGirl.create(
        :trip,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::PLANNED
      )
    end

    it 'returns user drafts' do
      trips = UserTrips.list_drafts(user, 1)
      expect(trips.count).to eq 3
      trips.each do |trip|
        expect(trip.include_user(user)).to be true
        expect(trip.status_code).to eq(Trips::StatusCodes::DRAFT)
      end
    end

    it 'shows trips without dates last' do
      trips = UserTrips.list_drafts(user, 1)
      expect(trips.count).to eq 3
      expect(trips.first.start_date).not_to be_nil
      expect(trips.last.start_date).to be_nil
    end
  end
end
