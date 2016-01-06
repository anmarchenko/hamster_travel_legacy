# == Schema Information
#
# Table name: places
#
#  id       :integer          not null, primary key
#  mongo_id :string
#  day_id   :integer
#  city_id  :integer
#

describe Travels::Place do
  let(:place) {FactoryGirl.create(:trip, :with_filled_days).days.first.places.last}
  let(:place_empty) {FactoryGirl.create(:trip, :with_filled_days).days.first.places.first}

  describe '#city' do
    context 'when city is present' do
      let(:city) {place.city}
      it 'returns city from geo database' do
        expect(city).not_to be_blank
        expect(city.id).to eq place.city_id
        expect(city.name).to eq place.city_text
      end
    end
    context 'when no city' do
      let(:city) {place_empty.city}
      it 'returns nil' do
        expect(city).to be_nil
      end
    end
  end

  describe '#is_empty?' do
    context 'when place with no data' do
      it 'returns true' do
        expect(place_empty).to be_is_empty
      end
    end
    context 'when place has data' do
      it 'returns false' do
        expect(place).not_to be_is_empty
      end
    end
  end

  describe '#as_json' do
    let(:place_json) {place.as_json}

    it 'has right attributes' do
      expect(place_json['id']).not_to be_blank
      expect(place_json['id']).to be_a String
      expect(place_json['id']).to eq(place.id.to_s)
      expect(place_json['city_id']).to eq(place.city_id)
      expect(place_json['city_text']).to eq(place.city_text)
    end
  end
end
