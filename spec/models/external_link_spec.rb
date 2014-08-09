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
        expect(json['description']).to eq('Somesite.com')
      end
    end

  end

  describe '#description' do

    context 'when url is valid with www' do
      let(:link){FactoryGirl.create :external_link, url: 'www.site.ru/jfhdsjfhj/hjfd?dsd=23'}

      it 'returns capitalized host name without www' do
        expect(link.description).to eq 'Site.ru'
      end
    end
    context 'when url is valid without www' do
      let(:link){FactoryGirl.create :external_link, url: 'http://host.com/?'}

      it 'returns capitalized host name without www' do
        expect(link.description).to eq 'Host.com'
      end
    end
    context 'when url is valid with https' do
      let(:link){FactoryGirl.create :external_link, url: 'https://host.com/?'}

      it 'returns capitalized host name' do
        expect(link.description).to eq 'Host.com'
        expect(link.url).to eq 'https://host.com/?'
      end
    end
    context 'when url is not valid' do
      let(:link){FactoryGirl.create :external_link, url: 'not a url'}

      it 'returns empty string' do
        expect(link.description).to eq ''
      end
    end
    context 'when url is nil' do
      let(:link){FactoryGirl.create :external_link, url: nil}

      it 'returns empty string' do
        expect(link.description).to eq ''
      end
    end
  end

end
