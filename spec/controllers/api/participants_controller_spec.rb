# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Api::ParticipantsController do
  describe '#index' do
    let(:trip) { FactoryGirl.create(:trip, :with_users, :with_invited) }

    it 'returns list of participants and invited users' do
      get 'index', params: { id: trip.id }
      expect(response).to have_http_status 200
      json = JSON.parse(response.body)

      expect(json['users'].count).to eq(3)
      expect(json['invited_users'].count).to eq(1)
    end
  end
end
