# frozen_string_literal: true

# == Schema Information
#
# Table name: days
#
#  id        :integer          not null, primary key
#  date_when :date
#  comment   :text
#  trip_id   :integer
#  index     :integer
#

require 'rails_helper'
RSpec.describe Travels::Day do
  describe '#init' do
    let(:day) { FactoryGirl.create(:trip).days.ordered.first }

    it 'has at least one place' do
      expect(day.places.count).to eq(1)
    end

    it 'has hotel' do
      expect(day.hotel).not_to be_blank
    end
  end

  describe '#empty_content?' do
    let(:day) { FactoryGirl.create(:trip).days.ordered.first }
    context 'default day' do
      it 'is true' do
        expect(day).to be_empty_content
      end
    end

    context 'when commented day' do
      before { day.comment = 'some comment' }
      it 'is false' do
        expect(day).not_to be_empty_content
      end
    end

    context 'when day has empty expenses' do
      before { day.expenses.create(FactoryGirl.build(:expense).attributes) }

      it 'is true' do
        expect(day).to be_empty_content
      end
    end

    context 'when day has non empty expenses' do
      before do
        day.expenses.create(FactoryGirl.build(:expense, :with_data).attributes)
      end

      it 'is true' do
        expect(day).not_to be_empty_content
      end
    end

    context 'when day has empty transfer' do
      before { day.transfers.create(FactoryGirl.build(:transfer).attributes) }
      it 'is false' do
        expect(day).not_to be_empty_content
      end
    end

    context 'when day has non empty transfer' do
      before do
        day.transfers.create(
          FactoryGirl.build(:transfer, :with_data).attributes
        )
      end
      it 'is false' do
        expect(day).not_to be_empty_content
      end
    end

    context 'when day has empty activity' do
      before { day.activities.create(FactoryGirl.build(:activity).attributes) }
      it 'is false' do
        expect(day).not_to be_empty_content
      end
    end

    context 'when day has non empty transfer' do
      before do
        day.activities.create(
          FactoryGirl.build(:activity, :with_data).attributes
        )
      end
      it 'is false' do
        expect(day).not_to be_empty_content
      end
    end

    context 'when day has empty places' do
      before { day.places.create(FactoryGirl.build(:place).attributes) }
      it 'is true' do
        expect(day).to be_empty_content
      end
    end

    context 'when day has non empty place' do
      before do
        day.places.create(FactoryGirl.build(:place, :with_data).attributes)
      end
      it 'is false' do
        expect(day).not_to be_empty_content
      end
    end

    context 'when day has non empty hotel' do
      before do
        day.hotel = Travels::Hotel.new(
          FactoryGirl.build(:hotel, :with_data).attributes
        )
      end
      it 'is false' do
        expect(day).not_to be_empty_content
      end
    end
  end
end
