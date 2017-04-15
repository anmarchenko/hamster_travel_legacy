# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trips do
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
        trips = Trips.list(nil).to_a
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
        trips = Trips.list(2)
        expect(trips.to_a.size).to eq(1)
      end
    end
  end

  describe '.list_user_trips' do
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
      trips = ::Trips.list_user_trips(user, 1)
      expect(trips.count).to eq 2
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
        status_code: Trips::StatusCodes::FINISHED
      )
      # user trips
      # drafts
      FactoryGirl.create_list(:trip, 2, user_ids: [user.id])
      # finished
      FactoryGirl.create(
        :trip,
        user_ids: [user.id],
        status_code: Trips::StatusCodes::FINISHED
      )
      # private user trip
      FactoryGirl.create(
        :trip,
        user_ids: [user.id],
        name: 'tripppppppp',
        private: true,
        status_code: Trips::StatusCodes::FINISHED
      )
    end

    it 'searches for public trips by name' do
      res = ::Trips.search('trip')
      expect(res.count).to eq(2) # all public trips
    end

    it 'returns empty result if nothing is found' do
      res = ::Trips.search('tripsssss')
      expect(res.count).to eq(0)
      res = ::Trips.search('trippppp')
      expect(res.count).to eq(0)
    end

    it 'searches for trips visible by user' do
      res = ::Trips.search('trippppp', user)
      expect(res.count).to eq(1)
      res = ::Trips.search('trip', user)
      expect(res.count).to eq(5)
    end
  end

  describe '#last_non_empty_day_index' do
    let(:trip_empty) { FactoryGirl.create(:trip) }
    let(:trip_full) { FactoryGirl.create(:trip, :with_filled_days) }

    it 'returns -1 if all days are empty' do
      expect(Trips.last_non_empty_day_index(trip_empty)).to eq(-1)
    end

    it 'returns last day index if all days are non-empty' do
      expect(Trips.last_non_empty_day_index(trip_full)).to eq(2)
    end

    it 'returns last non-empty day index' do
      trip_empty.days[0].comment = 'comment'
      trip_empty.days[0].save
      trip_empty.days[1].comment = 'comment'
      trip_empty.days[1].save
      expect(Trips.last_non_empty_day_index(trip_empty)).to eq(1)
    end
  end

  describe '#name_for_file' do
    subject { Trips.docx_file_name(trip) }

    context 'for normal trip' do
      let(:trip) { FactoryGirl.create(:trip, name: 'simple') }

      it 'returns name' do
        expect(subject).to eq "#{trip.name}.docx"
      end
    end
    context 'for trip name with slash and spaces' do
      let(:trip) do
        FactoryGirl.create(:trip, name: 'trip with spaces/slash_underscore')
      end

      it 'returns safe name' do
        expect(subject).to eq 'trip_with_spaces_slash_underscore.docx'
      end
    end
    context 'for russian trip name' do
      let(:trip) do
        FactoryGirl.create(:trip, name: 'Дубай в мае')
      end

      it 'returns safe name' do
        expect(subject).to eq 'Дубай_в_мае.docx'
      end
    end
    context 'for long trip name' do
      let(:trip) do
        FactoryGirl.create(
          :trip,
          name: 'very very very very very very very very ' \
                'very very very very very very very very ' \
                'very very very very long name'
        )
      end

      it 'returns safe name' do
        expect(subject).to eq(
          'very_very_very_very_very_very_very_very_very_very_.docx'
        )
      end
    end
  end
end
