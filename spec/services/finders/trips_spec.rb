# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Finders::Trips do
  describe '.all' do
    context 'logic' do
      before do
        FactoryGirl.create(:trip) # draft
        FactoryGirl.create_list(
          :trip,
          2,
          status_code: Trips::StatusCodes::PLANNED
        )
        FactoryGirl.create_list(
          :trip,
          3,
          status_code: Trips::StatusCodes::FINISHED
        )
        FactoryGirl.create(
          :trip,
          status_code: Trips::StatusCodes::FINISHED,
          private: true
        )
      end
      it 'returns all trips except private, first page by default' do
        trips = Finders::Trips.all(nil).to_a
        expect(trips.size).to eq 5
        # check sort
        trips.each_with_index do |_, i|
          next if trips[i + 1].blank?
          expect(
            trips[i].status_code > trips[i + 1].status_code ||
            (
              trips[i].status_code == trips[i + 1].status_code &&
              trips[i].start_date >= trips[i + 1].start_date
            )
          ).to be true
          expect(trips[i].private).to be false
        end
      end
    end

    context 'pagination' do
      before do
        FactoryGirl.create_list(
          :trip,
          11,
          status_code: Trips::StatusCodes::FINISHED
        )
      end

      it 'paginates trips' do
        trips = Finders::Trips.all(2)
        expect(trips.to_a.size).to eq(1)
      end
    end
  end

  describe '.for_user' do
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
      trips = Finders::Trips.for_user(user, 1)
      expect(trips.count).to eq 2
    end
  end

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
