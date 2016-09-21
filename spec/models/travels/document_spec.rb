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

describe Travels::Document do
  describe '.create' do
    let(:trip) {FactoryGirl.create(:trip, :with_filled_days)}
    let(:file) { File.open("#{::Rails.root}/spec/fixtures/files/cat.jpg") }

    it 'is possible to create new document for given trip' do
      document = Travels::Document.new(name: 'My awesome cat', trip: trip, mime_type: 'image/jpeg')
      document.store(file)
      document.save

      expect(trip.documents.count).to eq(1)
      doc = trip.documents.first
      expect(doc.name).to eq('My awesome cat')
      expect(doc.mime_type).to eq('image/jpeg')
      expect(doc.file.remote_url =~ /\/system\/dragonfly\/test\/[A-Za-z0-9]{2}\/[A-Za-z0-9]{2}\/[A-Za-z0-9]{2}\/[A-Za-z0-9]{10}\/[A-Za-z0-9]{32}\.jpg/).not_to be_blank
    end
  end
end
