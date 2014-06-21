describe ExternalLink do

  describe '#as_json' do

    context 'when non empty object' do
      let(:link) {FactoryGirl.create(:external_link)}

      it 'has right attributes as json' do
        json = link.as_json()
        expect(json).not_to be_blank
        expect(json.keys).to contain_exactly('id', 'description', 'url')

        expect(json['id']).to be_instance_of(String)
        expect(json['url']).to eq('http://www.somesite.com')
        expect(json['description']).to eq('external_link_description')
      end
    end

  end

end
