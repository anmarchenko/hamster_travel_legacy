# frozen_string_literal: true

# == Schema Information
#
# Table name: external_links
#
#  id            :integer          not null, primary key
#  description   :string
#  url           :text
#  linkable_id   :integer
#  linkable_type :string
#

require 'rails_helper'
RSpec.describe ExternalLink do
  describe '#description' do
    context 'when url is valid with www' do
      let(:link) do
        FactoryGirl.create(
          :external_link, url: 'www.site.ru/jfhdsjfhj/hjfd?dsd=23'
        )
      end

      it 'returns capitalized host name without www' do
        expect(link.description).to eq 'Site.ru'
      end
    end
    context 'when url is valid without www' do
      let(:link) { FactoryGirl.create :external_link, url: 'http://host.com/?' }

      it 'returns capitalized host name without www' do
        expect(link.description).to eq 'Host.com'
      end
    end
    context 'when url is valid with https' do
      let(:link) do
        FactoryGirl.create :external_link, url: 'https://host.com/?'
      end

      it 'returns capitalized host name' do
        expect(link.description).to eq 'Host.com'
        expect(link.url).to eq 'https://host.com/?'
      end
    end
    context 'when url is not valid' do
      let(:link) { FactoryGirl.create :external_link, url: 'not a url' }

      it 'returns empty string' do
        expect(link.description).to eq ''
      end
    end
    context 'when url is nil' do
      let(:link) { FactoryGirl.create :external_link, url: nil }

      it 'returns empty string' do
        expect(link.description).to eq ''
      end
    end
  end
end
