# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Views::DayView do
  describe '.reordering_show' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:days) { Trips::Days.list(trip) }
    let(:day) { days.first }
    subject { Views::DayView.reordering_show(day) }

    it 'returns short representation of the day with 3 must see activities' do
      expected_activities = day.activities
                               .order(rating: :desc, order_index: :asc)
                               .first(3)
      actual_activities = subject[:activity_s].split('<br/>').first(3)
      3.times do |index|
        expect(actual_activities[index]).to eq(
          "#{index + 1}. #{expected_activities[index].name}"
        )
      end
    end

    context 'day_info_s' do
      context 'when expenses present' do
        let(:expense) { Trips::Expenses.list(day).first }
        it 'renders expense info' do
          expect(subject[:day_info_s]).to eq(
            "#{expense.name} #{expense.amount.to_f}" \
            " #{expense.amount.currency.symbol}"
          )
        end
      end

      context 'when no expenses but links present' do
        before do
          day.expenses.destroy_all
          day.links.create(url: 'http://example.com')
        end

        it 'renders link info' do
          expect(subject[:day_info_s]).to eq('Example.com')
        end
      end

      context 'when no expenses and no links present' do
        before do
          day.expenses.destroy_all
        end

        it 'renders nil' do
          expect(subject[:day_info_s]).to be_nil
        end
      end
    end
  end

  describe '#show_json' do
    let(:user) { FactoryGirl.create(:user, currency: 'EUR') }
    context 'when return json of a filled day' do
      let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
      let(:days) { Trips::Days.list(trip) }
      let(:day) { days.first }

      let(:day_json) do
        Views::DayView.show_json(
          day,
          %i[expenses activities links places transfers hotel]
        )
      end

      let(:trip_empty) { FactoryGirl.create(:trip) }
      let(:trip_empty_days) { Trips::Days.list(trip_empty) }
      let(:day_empty) { trip_empty_days.first }
      let(:day_empty_json) do
        Views::DayView.show_json(
          day_empty,
          %i[expenses activities links places transfers hotel]
        )
      end

      let(:day_json_with_currency) do
        Views::DayView.show_json(
          day,
          %i[expenses activities links places transfers hotel],
          user
        )
      end

      it 'has string id field' do
        expect(day_json['id']).not_to be_blank
        expect(day_json['id']).to be_a(String)
      end

      it 'has date in right format' do
        expect(day_json['date']).to eq(
          I18n.l(day.date_when, format: '%d.%m.%Y %A')
        )
      end

      it 'has 2 places' do
        expect(day_json['places'].count).to eq(2)
        expect(day_json['places']).to eq(
          Views::PlaceView.index_json(
            day.places
          )
        )
      end

      it 'has 2 transfers' do
        expect(day_json['transfers'].count).to eq(2)
        expect(day_json['transfers']).to eq(
          Views::TransferView.index_json(
            Trips::Transfers.list(day)
          )
        )
      end

      it 'has 5 activities' do
        expect(day_json['activities'].count).to eq(3)
        expect(day_json['activities']).to eq(
          Views::ActivityView.index_json(
            Trips::Activities.list(day)
          )
        )
      end

      it 'has comment' do
        expect(day_json['comment']).to eq(day.comment)
      end

      it 'has hotel' do
        expect(day_json['hotel']).to eq(
          Views::HotelView.show_json(day.hotel)
        )
      end

      it 'when empty has at least one expense' do
        expect(day_empty_json['expenses'].count).to eq(1)
      end

      it 'has 2 expenses as defined in factory' do
        expect(day_json['expenses'].count).to eq(2)
        expect(day_json['expenses'].last).to eq(
          Views::ExpenseView.show_json(day.expenses.last)
        )
      end

      it 'adds amounts in user currency' do
        expect(
          day_json_with_currency['expenses']
            .first['in_user_currency'][:amount_cents]
        ).not_to be_blank
      end
    end
  end
end
