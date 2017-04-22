# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Views::HotelView do
  describe '#show_json' do
    let(:day) { Trips::Days.list(trip).first }
    let(:hotel) { day.hotel }
    let(:hotel_json) { subject.show_json hotel }

    context 'filled with data' do
      let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }

      it 'has right attributes' do
        expect(hotel_json['id']).not_to be_blank
        expect(hotel_json['id']).to be_a String
        expect(hotel_json['id']).to eq(hotel.id.to_s)
        expect(hotel_json['name']).to eq(hotel.name)
        expect(hotel_json['amount_cents']).to eq(hotel.amount_cents)
        expect(hotel_json['amount_currency']).to eq(hotel.amount_currency)
        expect(hotel_json['amount_currency_text']).to eq(
          hotel.amount.currency.symbol
        )
        expect(hotel_json['comment']).to eq(hotel.comment)
        expect(hotel_json['links'].count).to eq 1
        expect(hotel_json['links'][0]).to eq(
          Views::LinkView.show_json(hotel.links.first)
        )
      end
    end

    context 'not filled' do
      let(:trip) { FactoryGirl.create(:trip) }

      it 'has at least 1 link' do
        expect(hotel_json['links']).to be_a Array
        expect(hotel_json['links'].count).to eq 1
      end
    end
  end
end
