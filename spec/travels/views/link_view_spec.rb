# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Views::LinkView do
  describe '#show_json' do
    context 'when non empty object' do
      let(:link) { FactoryGirl.create(:external_link) }

      it 'has right attributes as json' do
        json = Views::LinkView.show_json(link)
        expect(json).not_to be_blank
        expect(json.keys).to contain_exactly('id', 'description', 'url')

        expect(json['id']).to be_instance_of(String)
        expect(json['url']).to eq('http://www.somesite.com')
        expect(json['description']).to eq('Somesite.com')
      end
    end
  end
end
