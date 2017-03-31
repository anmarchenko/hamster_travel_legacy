# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Updaters::DayLinks do
  def first_day_of(tr)
    tr.reload.days.first
  end

  let(:trip) { FactoryGirl.create(:trip) }
  let(:day) { first_day_of trip }

  describe '#process' do
    context 'when params have day links data' do
      let(:params) do
        [
          {
            id: nil,
            url: 'https://google.com',
            description: 'fds'
          }.with_indifferent_access
        ]
      end

      it 'updates expenses attributes' do
        Updaters::DayLinks.new(day, params).process
        links = first_day_of(trip).links
        expect(links.count).to eq 1
        expect(links.first.url).to eq 'https://google.com'
      end
    end
  end
end
