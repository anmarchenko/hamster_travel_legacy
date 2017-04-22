# frozen_string_literal: true

# == Schema Information
#
# Table name: transfers
#
#  id              :integer          not null, primary key
#  order_index     :integer
#  type            :string
#  code            :string
#  company         :string
#  link            :string
#  station_from    :string
#  station_to      :string
#  start_time      :datetime
#  end_time        :datetime
#  comment         :text
#  day_id          :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#  city_to_id      :integer
#  city_from_id    :integer
#

require 'rails_helper'
RSpec.describe Travels::Transfer do
  let(:trip) { FactoryGirl.create(:trip, :with_transfers) }
  let(:day) { Trips::Days.list(trip).first }
  let(:transfers) { Trips::Transfers.list(day).to_a }
  let(:transfer) { transfers[1] }

  describe '#city_from' do
    let(:city) { transfer.city_from }
    it 'returns city from geo database' do
      expect(city).not_to be_blank
      expect(city.id).to eq transfer.city_from_id
      expect(city.name).to eq transfer.city_from_text
    end
  end

  describe '#city_to' do
    let(:city) { transfer.city_to }
    it 'returns city from geo database' do
      expect(city).not_to be_blank
      expect(city.id).to eq transfer.city_to_id
      expect(city.name).to eq transfer.city_to_text
    end
  end
end
