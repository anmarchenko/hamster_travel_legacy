# frozen_string_literal: true
require 'rails_helper'
RSpec.fdescribe Finders::Trips do
  describe '.all' do
    context 'logic' do
      before do
        FactoryGirl.create(:trip) # draft
        FactoryGirl.create_list(
          :trip,
          2,
          status_code: Travels::Trip::StatusCodes::PLANNED
        )
        FactoryGirl.create_list(
          :trip,
          3,
          status_code: Travels::Trip::StatusCodes::FINISHED
        )
        FactoryGirl.create(
          :trip,
          status_code: Travels::Trip::StatusCodes::FINISHED,
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
          status_code: Travels::Trip::StatusCodes::FINISHED
        )
      end

      it 'paginates trips' do
        trips = Finders::Trips.all(2)
        expect(trips.to_a.size).to eq(1)
      end
    end
  end

  describe '.search' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      # draft
      FactoryGirl.create(:trip)
      # public
      FactoryGirl.create(
        :trip,
        status_code: Travels::Trip::StatusCodes::FINISHED
      )
      # user trips
      # drafts
      FactoryGirl.create_list(:trip, 2, user_ids: [user.id])
      # finished
      FactoryGirl.create(
        :trip,
        user_ids: [user.id],
        status_code: Travels::Trip::StatusCodes::FINISHED
      )
      # private user trip
      FactoryGirl.create(
        :trip,
        user_ids: [user.id],
        name: 'tripppppppp',
        private: true,
        status_code: Travels::Trip::StatusCodes::FINISHED
      )
    end

    it 'searches for public trips by name' do
      res = Finders::Trips.search('trip')
      expect(res.count).to eq(2) # all public trips
    end

    it 'returns empty result if nothing is found' do
      res = Finders::Trips.search('tripsssss')
      expect(res.count).to eq(0)
      res = Finders::Trips.search('trippppp')
      expect(res.count).to eq(0)
    end

    it 'searches for trips visible by user' do
      res = Finders::Trips.search('trippppp', user)
      expect(res.count).to eq(1)
      res = Finders::Trips.search('trip', user)
      expect(res.count).to eq(5)
    end
  end
end
