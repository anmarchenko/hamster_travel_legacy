# frozen_string_literal: true

# == Schema Information
#
# Table name: hotels
#
#  id              :integer          not null, primary key
#  name            :string
#  comment         :text
#  day_id          :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#

require 'rails_helper'
RSpec.describe Travels::Hotel do
  describe '#empty_content?' do
    let(:hotel) { FactoryGirl.create(:trip).days.ordered.first.hotel }

    context 'when no hotel data' do
      it 'returns true' do
        expect(hotel.empty_content?).to be true
      end
    end
    context 'when hotel has name' do
      before { hotel.update_attributes(name: 'name') }
      it 'returns false' do
        expect(hotel.empty_content?).to be false
      end
    end
    context 'when hotel has price' do
      before { hotel.update_attributes(amount_cents: 1) }
      it 'returns false' do
        expect(hotel.empty_content?).to be true
      end
    end
    context 'when hotel has comment' do
      before { hotel.update_attributes(comment: 'comment') }
      it 'returns false' do
        expect(hotel.empty_content?).to be false
      end
    end
    context 'when hotel has non-empty link' do
      before do
        hotel.links.create(FactoryGirl.build(:external_link).attributes)
      end
      it 'returns false' do
        expect(hotel.empty_content?).to be false
      end
    end

    context 'when hotel has empty links' do
      before { hotel.links.create({}) }
      it 'returns true' do
        expect(hotel.empty_content?).to be true
      end
    end
  end
end
