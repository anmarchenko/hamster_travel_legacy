describe Geo::City do
  describe '#find_by_term' do

    def check_order_and_term cities
      cities.each_with_index do |city, index|
        next if cities[index + 1].blank?
        expect(cities[index + 1].population).to be < cities[index].population
      end
    end

    it 'finds by english name' do
      term = 'city 1'
      cities = Geo::City.find_by_term(term).to_a
      cities.each { |city| expect(city.name_en =~ /#{term}/i).not_to be_blank }
      check_order_and_term cities
    end

    it 'finds by russian name' do
      term = 'город 1'
      cities = Geo::City.find_by_term(term).to_a
      cities.each { |city| expect(city.name_ru =~ /#{term}/i).not_to be_blank }
      check_order_and_term cities
    end

  end

  describe '#translated_text' do

    let(:region) {Geo::Region.first}
    let(:country) {region.country}

    context 'when city has region and country' do
      let(:city) {FactoryGirl.create :city, region_code: region.geonames_code, country_code: country.geonames_code}

      it 'returns city name with region and country' do
        expect(city.translated_text).to eq "#{city.translated_name}, #{region.translated_name}, #{country.translated_name}"
        expect(city.translated_text(with_region: false,
                                    locale: I18n.locale,
                                    with_country: true)).to eq "#{city.translated_name}, #{country.translated_name}"
        expect(city.translated_text(with_country: false,
                                    locale: I18n.locale,
                                    with_region: true)).to eq "#{city.translated_name}, #{region.translated_name}"
      end
    end

    context 'when city has country' do
      let(:city) {FactoryGirl.create :city, country_code: country.geonames_code}

      it 'returns city name with region' do
        expect(city.translated_text).to eq "#{city.translated_name}, #{country.translated_name}"
      end
    end

    context 'when city has no region and country' do
      let(:city) {FactoryGirl.create :city}

      it 'returns city name with region' do
        expect(city.translated_text).to eq "#{city.translated_name}"
      end
    end

  end
end