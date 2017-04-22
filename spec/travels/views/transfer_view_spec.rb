# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Views::TransferView do
  let(:trip) { FactoryGirl.create(:trip, :with_transfers) }
  let(:day) { Trips::Days.list(trip).first }
  let(:transfers) { Trips::Transfers.list(day).to_a }

  let(:transfer_empty) { transfers[0] }
  let(:transfer_flight) { transfers[2] }
  let(:transfer_json) { subject.show_json transfer_flight }

  describe '#show_json' do
    it 'has right attributes' do
      expect(transfer_json['id']).not_to be_blank
      expect(transfer_json['id']).to be_a String
      expect(transfer_json['id']).to eq(transfer_flight.id.to_s)
      expect(transfer_json['type_icon']).to eq(
        subject.type_icon(transfer_flight)
      )
      expect(transfer_json['start_time']).to eq(
        transfer_flight.start_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00')
      )
      expect(transfer_json['end_time']).to eq(
        transfer_flight.end_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00')
      )
      expect(transfer_json['company']).to eq(transfer_flight.company)
    end
  end

  describe '#type_icon' do
    context 'when empty transfer type' do
      it 'is nil' do
        expect(
          subject.type_icon(transfer_empty)
        ).to start_with('/assets/transfers/arrow')
      end
    end
    context 'when transfer has type' do
      it 'is from constant' do
        expect(
          subject.type_icon(transfer_flight)
        ).to start_with('/assets/transfers/plane')
      end
    end
  end
end
