# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Views::PlaceView do
  describe '#show_json' do
    let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }
    let(:day) { Trips::Days.list(trip).first }
    let(:place) { day.places.last }
    let(:place_json) { subject.show_json place }

    it 'has right attributes' do
      expect(place_json['id']).not_to be_blank
      expect(place_json['id']).to be_a String
      expect(place_json['id']).to eq(place.id.to_s)
      expect(place_json['city_id']).to eq(place.city_id)
      expect(place_json['city_text']).to eq(place.city_text)
    end
  end
end
