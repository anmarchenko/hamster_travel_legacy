# == Schema Information
#
# Table name: transfers
#
#  id              :integer          not null, primary key
#  order_index     :integer
#  city_from_code  :string
#  city_from_text  :string
#  city_to_code    :string
#  city_to_text    :string
#  type            :string
#  type_icon       :string
#  code            :string
#  company         :string
#  link            :string
#  station_from    :string
#  station_to      :string
#  start_time      :datetime
#  end_time        :datetime
#  comment         :text
#  mongo_id        :string
#  day_id          :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("RUB"), not null
#

describe Travels::Transfer do
  let(:trip) {FactoryGirl.create(:trip, :with_transfers)}
  let(:transfers) {trip.days.first.transfers.to_a}

  let(:transfer_empty) {transfers[0]}
  let(:transfer) {transfers[1]}
  let(:transfer_flight) {transfers[2]}

  describe '#type_icon' do
    context 'when empty transfer type' do
      it 'is nil' do
        expect(transfer_empty.type_icon).to be_nil
      end
    end
    context 'when transfer has type' do
      it 'is from constant' do
        expect(transfer_flight.type_icon).to eq('fa fa-plane')
      end
    end
  end

  describe '#city_from' do
    let(:city) {transfer.city_from}
    it 'returns city from geo database' do
      expect(city).not_to be_blank
      expect(city.id).to eq transfer.city_from_id
      expect(city.name).to eq transfer.city_from_text
    end
  end

  describe '#city_to' do
    let(:city) {transfer.city_to}
    it 'returns city from geo database' do
      expect(city).not_to be_blank
      expect(city.id).to eq transfer.city_to_id
      expect(city.name).to eq transfer.city_to_text
    end
  end

  describe '#as_json' do
    let(:transfer_json) {transfer_flight.as_json}

    it 'has right attributes' do
      expect(transfer_json['id']).not_to be_blank
      expect(transfer_json['id']).to be_a String
      expect(transfer_json['id']).to eq(transfer_flight.id.to_s)
      expect(transfer_json['type_icon']).to eq(transfer_flight.type_icon)
      expect(transfer_json['start_time']).to eq(transfer_flight.start_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00'))
      expect(transfer_json['end_time']).to eq(transfer_flight.end_time.try(:strftime, '%Y-%m-%dT%H:%M+00:00'))
      expect(transfer_json['company']).to eq(transfer_flight.company)
    end
  end
end
