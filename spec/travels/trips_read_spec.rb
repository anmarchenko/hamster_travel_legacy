# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trips do
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
