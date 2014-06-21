describe ExternalLink do

  describe '#as_json' do

    context 'when non empty object' do

      let(:link) {FactoryGirl.create(:external_link)}

      it 'has right attributes as json' do
        expect(link).to be_valid
      end

    end

  end

end
