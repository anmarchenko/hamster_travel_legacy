# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Trips::Days do
  let(:trip) { FactoryGirl.create(:trip) }
  let(:day) { trip.days.ordered.first }

  let(:params) do
    {
      name: 'new_name',
      comment: 'new_comment',
      amount_cents: 123,
      amount_currency: 'EUR',
      links: [{ url: 'http://new.url', description: 'new_description' }]
    }.with_indifferent_access
  end

  it 'updates hotel attributes' do
    Trips::Days.save_hotel(day, hotel: params)

    hotel = day.reload.hotel
    expect(hotel.name).to eq 'new_name'
    expect(hotel.comment).to eq 'new_comment'
    expect(hotel.amount).to eq Money.new(123, 'EUR')
    expect(hotel.links.count).to eq 1
    expect(hotel.links.first.url).to eq 'http://new.url'
    expect(hotel.links.first.description).to eq 'New.url'
  end

  it 'updates hotel link data' do
    Trips::Days.save_hotel(day, hotel: params)

    hotel = day.reload.hotel
    params[:links] = [
      {
        id: hotel.links.first.id.to_s,
        url: 'http://updated.url'
      }
    ]
    Trips::Days.save_hotel(day, hotel: params)

    updated_hotel = day.reload.hotel
    expect(updated_hotel.links.count).to eq 1
    expect(updated_hotel.links.first.id).to eq hotel.links.first.id
    expect(updated_hotel.links.first.url).to eq 'http://updated.url'
    expect(updated_hotel.links.first.description).to eq 'Updated.url'
  end

  it 'removes hotel name and price' do
    Trips::Days.save_hotel(day, hotel: params)

    params[:name] = ''
    params[:amount_cents] = ''
    params[:comment] = ''

    Trips::Days.save_hotel(day, hotel: params)

    updated_hotel = day.reload.hotel
    expect(updated_hotel.name).to be_blank
    expect(updated_hotel.amount_cents).to eq(0)
    expect(updated_hotel.comment).to be_blank
  end

  it 'removes hotel link' do
    Trips::Days.save_hotel(day, hotel: params)

    params.delete(:links)

    Trips::Days.save_hotel(day, hotel: params)

    updated_hotel = day.reload.hotel
    expect(updated_hotel.links.count).to eq 0
  end
end
