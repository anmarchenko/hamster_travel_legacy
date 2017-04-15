# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Finders::Trips do
  describe '.drafts' do
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
      trips = Finders::Trips.drafts(user, 1)
      expect(trips.count).to eq 3
      trips.each do |trip|
        expect(trip.include_user(user)).to be true
        expect(trip.status_code).to eq(Trips::StatusCodes::DRAFT)
      end
    end

    it 'shows trips without dates last' do
      trips = Finders::Trips.drafts(user, 1)
      expect(trips.count).to eq 3
      expect(trips.first.start_date).not_to be_nil
      expect(trips.last.start_date).to be_nil
    end
  end
end
