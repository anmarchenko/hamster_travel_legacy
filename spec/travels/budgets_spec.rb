# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Budgets do
  describe '.calculate_info' do
    context 'when empty trip' do
      let(:trip) { FactoryGirl.create(:trip) }

      it 'returns zero' do
        expect(Budgets.calculate_info(trip).sum).to eq(0)
      end
    end

    context 'when filled trip' do
      let(:trip) do
        FactoryGirl.create(:trip, :with_filled_days, :with_caterings)
      end

      it 'returns right budget in right currency' do
        hotel_price = trip.days.inject(0) do |sum, day|
          sum + ((day.hotel.amount_cents || 0))
        end
        days_add_price = trip.days.inject(0) do |sum, day|
          sum + day.expenses.inject(0) do |i_s, ex|
            i_s + ((ex.amount_cents || 0))
          end
        end
        transfers_price = trip.days.inject(0) do |s, day|
          s + day.transfers.inject(0) do |i_s, tr|
            i_s + ((tr.amount_cents || 0))
          end
        end
        activities_price = trip.days.inject(0) do |s, day|
          s + day.activities.inject(0) do |i_s, ac|
            i_s + ((ac.amount_cents || 0))
          end
        end
        caterings_price = trip.caterings.inject(0) do |s, cat|
          s + ((cat.amount_cents || 0)) * cat.days_count * cat.persons_count
        end

        budget_eur = Budgets.calculate_info(trip, 'EUR').sum
        should_be_eur = Money.new(
          [hotel_price, days_add_price,
           transfers_price, activities_price,
           caterings_price].reduce(&:+), 'RUB'
        ).exchange_to('EUR').to_f
        expect((budget_eur - should_be_eur).abs).to be < 1.0
      end
    end
  end
end
