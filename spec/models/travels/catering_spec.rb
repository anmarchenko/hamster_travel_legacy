# frozen_string_literal: true

# == Schema Information
#
# Table name: caterings
#
#  id              :integer          not null, primary key
#  description     :text
#  days_count      :integer
#  persons_count   :integer
#  trip_id         :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#  order_index     :integer
#  name            :string
#

require 'rails_helper'
RSpec.describe Travels::Catering do
  describe '.create' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }

    it 'creates new catering model and back references to trip' do
      catering = trip.caterings.create(FactoryGirl.build(:catering).attributes)

      catering = catering.reload
      expect(catering.persisted?).to be_truthy
      expect(catering.trip_id).to eq(trip.id)
    end
  end
end
