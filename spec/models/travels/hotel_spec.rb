describe Travels::Hotel do
  describe '#is_empty?' do
    let(:hotel) {FactoryGirl.create(:trip).days.first.hotel}

    context 'when no hotel data' do
      it 'returns true' do
        expect(hotel.is_empty?).to be true
      end
    end
    context 'when hotel has name' do
      before {hotel.update_attributes(name: 'name')}
      it 'returns false' do
        expect(hotel.is_empty?).to be false
      end
    end
    context 'when hotel has price' do
      before {hotel.update_attributes(amount_cents: 1)}
      it 'returns false' do
        expect(hotel.is_empty?).to be true
      end
    end
    context 'when hotel has comment' do
      before {hotel.update_attributes(comment: 'comment')}
      it 'returns false' do
        expect(hotel.is_empty?).to be false
      end
    end
    context 'when hotel has non-empty link' do
      before {hotel.links.create(FactoryGirl.build(:external_link).attributes)}
      it 'returns false' do
        expect(hotel.is_empty?).to be false
      end
    end

    context 'when hotel has empty links' do
      before {hotel.links.create({})}
      it 'returns true' do
        expect(hotel.is_empty?).to be true
      end
    end
  end

  describe 'as_json' do
    context 'filled with data' do
      let(:hotel) {FactoryGirl.create(:trip, :with_filled_days).days.first.hotel}
      let(:hotel_json) {hotel.as_json}

      it 'has right attributes' do
        expect(hotel_json['id']).not_to be_blank
        expect(hotel_json['id']).to be_a String
        expect(hotel_json['id']).to eq(hotel.id.to_s)
        expect(hotel_json['name']).to eq(hotel.name)
        expect(hotel_json['amount_cents']).to eq(hotel.amount_cents / 100)
        expect(hotel_json['amount_currency']).to eq(hotel.amount_currency)
        expect(hotel_json['amount_currency_text']).to eq(hotel.amount.currency.symbol)
        expect(hotel_json['comment']).to eq(hotel.comment)
        expect(hotel_json['links']).to be_a Array
        expect(hotel_json['links'].count).to eq 1
        expect(hotel_json['links'][0]).to eq hotel.links.first.as_json
      end
    end

    context 'not filled' do
      let(:hotel) {FactoryGirl.create(:trip).days.first.hotel}
      let(:hotel_json) {hotel.as_json}

      it 'has at least 1 link' do
        expect(hotel_json['links']).to be_a Array
        expect(hotel_json['links'].count).to eq 1
      end

    end
  end
end