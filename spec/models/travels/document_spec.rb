# frozen_string_literal: true

# == Schema Information
#
# Table name: documents
#
#  id        :integer          not null, primary key
#  file_uid  :string
#  mime_type :string
#  trip_id   :integer
#  name      :string
#

require 'rails_helper'
RSpec.describe Travels::Document do
  let(:trip) { FactoryGirl.create(:trip, :with_filled_days) }

  describe '.create' do
    let(:file) { File.open("#{::Rails.root}/spec/fixtures/files/cat.jpg") }

    it 'is possible to create new document for given trip' do
      document = Travels::Document.new(
        name: 'My awesome cat', trip: trip, mime_type: 'image/jpeg'
      )
      document.store(file)
      document.save

      expect(trip.documents.count).to eq(1)
      doc = trip.documents.first
      expect(doc.name).to eq('My awesome cat')
      expect(doc.mime_type).to eq('image/jpeg')
      expect(doc.file.remote_url =~ %r{
        \/system\/dragonfly\/test\/
        [A-Za-z0-9]{2}\/[A-Za-z0-9]{2}\/
        [A-Za-z0-9]{2}\/[A-Za-z0-9]{10}\/
        [A-Za-z0-9]{32}\.jpg
      }x).not_to be_blank
    end
  end

  describe '#as_json' do
    let(:document) { FactoryGirl.create(:document, trip: trip) }

    it 'returns json representation of document' do
      json = document.as_json
      expect(json['id']).to eq(document.id)
      expect(json['name']).to eq(document.name)
      expect(json['mime_type']).to eq(document.mime_type)

      expect(json['file_uid']).to eq(nil)
      expect(json['trip_id']).to eq(nil)
    end
  end
end
