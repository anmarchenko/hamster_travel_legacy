describe Travels::Catering do
  describe '.create' do
    let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}

    it 'creates new catering model and back references to trip' do
      catering = trip.caterings.create(FactoryGirl.build(:catering).attributes)

      catering = catering.reload
      expect(catering.persisted?).to be_truthy
      expect(catering.trip_id).to eq(trip.id)
    end

  end

end