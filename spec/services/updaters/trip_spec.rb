# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Updaters::Trip do
  describe '#update' do
    context 'when trip has start and end date' do
      let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }

      it 'creates trip days on create' do
        expect(trip.days.count).to eq(3)
        expect(trip.days.first.date_when).to eq(trip.start_date)
        expect(trip.days.last.date_when).to eq(trip.end_date)
      end

      it 'recounts dates on update preserving other data' do
        Updaters::Trip.new(trip).update(
          start_date: 14.days.ago,
          end_date: 12.days.ago
        )
        updated_trip = trip.reload

        expect(updated_trip.days.count).to eq(3)
        expect(updated_trip.days.first.date_when).to eq(14.days.ago.to_date)
        expect(
          updated_trip.days.first.transfers.first.start_time.to_date
        ).to eq(
          updated_trip.days.first.date_when
        )
        expect(updated_trip.days.last.date_when).to eq(12.days.ago.to_date)
        expect(updated_trip.days.last.transfers.first.start_time.to_date).to eq(
          updated_trip.days.last.date_when
        )

        updated_trip.days.each_with_index do |day, index|
          expect(day.comment).to eq("Day #{index}")
        end
      end

      it 'creates new days when necessary' do
        Updaters::Trip.new(trip).update(
          start_date: 16.days.ago,
          end_date: 12.days.ago
        )
        updated_trip = trip.reload

        expect(updated_trip.days.count).to eq(5)
        expect(updated_trip.days.first.date_when).to eq(16.days.ago.to_date)
        expect(updated_trip.days.last.date_when).to eq(12.days.ago.to_date)
        expect(updated_trip.days.last.comment).to be_nil
      end

      it 'deletes days when necessary' do
        Updaters::Trip.new(trip).update(
          start_date: 13.days.ago,
          end_date: 12.days.ago
        )
        updated_trip = trip.reload

        expect(updated_trip.days.count).to eq(2)
        expect(updated_trip.days.first.date_when).to eq(13.days.ago.to_date)
        expect(updated_trip.days.last.date_when).to eq(12.days.ago.to_date)
        expect(updated_trip.days.last.comment).to eq('Day 1')
      end

      it 'converts to trip without dates without losing data' do
        Updaters::Trip.new(trip).update(
          planned_days_count: 3,
          dates_unknown: true
        )
        updated_trip = trip.reload

        expect(updated_trip.start_date).to be_nil
        expect(updated_trip.end_date).to be_nil

        expect(updated_trip.days.count).to eq(3)
        expect(updated_trip.days.first.date_when).to be_nil
        expect(updated_trip.days.last.date_when).to be_nil
        expect(updated_trip.days.last.comment).to eq('Day 2')
        expect(updated_trip.days.first.comment).to eq('Day 0')
      end
    end

    context 'when trip has only number of days' do
      let(:trip) { FactoryGirl.create(:trip, :no_dates, :with_filled_days) }

      it 'creates trip days on create' do
        expect(trip.days.count).to eq(3)
        expect(trip.days.first.date_when).to be_nil
        expect(trip.days.last.date_when).to be_nil
        expect(trip.days.first.index).to eq(0)
        expect(trip.days.last.index).to eq(2)
      end

      it 'creates new days when necessary' do
        Updaters::Trip.new(trip).update(planned_days_count: 5)
        updated_trip = trip.reload

        expect(updated_trip.days.count).to eq(5)
        expect(updated_trip.days.first.index).to eq(0)
        expect(updated_trip.days.last.index).to eq(4)

        expect(updated_trip.days.first.comment).to eq('Day 0')
        expect(updated_trip.days.last.comment).to eq(nil)
      end

      it 'deletes days when necessary' do
        Updaters::Trip.new(trip).update(planned_days_count: 2)
        updated_trip = trip.reload

        expect(updated_trip.days.count).to eq(2)
        expect(updated_trip.days.first.index).to eq(0)
        expect(updated_trip.days.last.index).to eq(1)

        expect(updated_trip.days.last.comment).to eq('Day 1')
      end

      it 'converts to trip with dates preserving data' do
        Updaters::Trip.new(trip).update(
          start_date: Date.today,
          end_date: Date.today + 4.days,
          dates_unknown: false
        )

        updated_trip = trip.reload

        expect(updated_trip.planned_days_count).to be_nil

        expect(updated_trip.days.count).to eq(5)
        expect(updated_trip.days.first.index).to eq(0)
        expect(updated_trip.days.last.index).to eq(4)
        expect(updated_trip.days.first.date_when).to eq(Date.today)
        expect(updated_trip.days.last.date_when).to eq(Date.today + 4.days)

        expect(updated_trip.days.last.comment).to be_nil
        expect(updated_trip.days.first.comment).to eq('Day 0')
      end
    end

    context 'caterings' do
      let(:empty_trip) { FactoryGirl.create(:trip) }
      let(:trip) do
        trip = FactoryGirl.create(:trip)
        trip.caterings = trip.create_caterings
        trip.save
        trip
      end
      let(:trip_with_caterings) do
        trip = FactoryGirl.create(:trip)
        trip.caterings = [
          FactoryGirl.build(:catering, days_count: 3),
          FactoryGirl.build(:catering, days_count: 3)
        ]
        trip.save
        trip
      end
      let(:trip_with_sepcific_catering) do
        trip = FactoryGirl.create(:trip)
        trip.caterings = [
          FactoryGirl.build(:catering, days_count: 6)
        ]
        trip.save
        trip
      end

      it 'creates catering with number of days equal to trip length' do
        expect(trip.caterings.count).to eq(1)
        expect(trip.caterings.first.days_count).to eq(3)
      end

      it 'updates catering days count when days are changed' do
        Updaters::Trip.new(trip).update(
          start_date: Date.today,
          end_date: Date.today + 4.days
        )
        expect(trip.caterings.count).to eq(1)
        expect(trip.caterings.first.days_count).to eq(5)
      end

      it 'does not update catering days count when trip is empty' do
        Updaters::Trip.new(empty_trip).update(
          start_date: Date.today,
          end_date: Date.today + 4.days
        )
        expect(empty_trip.caterings.count).to eq(0)
      end

      it 'does not update catering days count when there are few caterings' do
        Updaters::Trip.new(trip_with_caterings).update(
          start_date: Date.today, end_date: Date.today + 4.days
        )
        expect(trip_with_caterings.caterings.count).to eq(2)
        expect(trip_with_caterings.caterings.first.days_count).to eq(3)
        expect(trip_with_caterings.caterings.last.days_count).to eq(3)
      end

      it 'does not update catering days count when trip dates werent changed' do
        Updaters::Trip.new(trip_with_sepcific_catering).update(
          start_date: trip_with_sepcific_catering.start_date,
          end_date: trip_with_sepcific_catering.end_date,
          status_code: Travels::Trip::StatusCodes::PLANNED
        )
        expect(trip_with_sepcific_catering.caterings.count).to eq(1)
        expect(trip_with_sepcific_catering.caterings.first.days_count).to eq(6)
      end
    end
  end
end
