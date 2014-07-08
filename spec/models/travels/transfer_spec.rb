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
        expect(transfer_flight.type_icon).to eq('map-icon-airport')
      end
    end
  end
end