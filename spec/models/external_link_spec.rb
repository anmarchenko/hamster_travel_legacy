describe ExternalLink do

  describe '#as_json' do

    context 'when non empty object' do
      it 'should be valid' do
        link = FactoryGirl.create(:external_link)
        expect(link).to be_valid
      end
    end

  end

end
