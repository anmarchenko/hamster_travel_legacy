# frozen_string_literal: true

# == Schema Information
#
# Table name: cities
#
#  id                         :integer          not null, primary key
#  geonames_code              :string
#  geonames_modification_date :date
#  latitude                   :float
#  longitude                  :float
#  population                 :integer
#  country_code               :string
#  region_code                :string
#  district_code              :string
#  adm3_code                  :string
#  adm4_code                  :string
#  adm5_code                  :string
#  timezone                   :string
#  status                     :string
#

require 'rails_helper'

RSpec.describe Geo::City do
  describe '#find_by_term' do
    before do
      FactoryGirl.create_list(:city, 3)
    end

    def check_order_and_term(cities)
      cities.each_with_index do |_city, index|
        next if cities[index + 1].blank?
        expect(cities[index + 1].population).to be < cities[index].population
      end
    end

    it 'finds by english name' do
      term = 'city'
      cities = Geo::City.find_by_term(term).to_a
      I18n.locale = :en
      cities.each { |city| expect(city.name =~ /#{term}/i).not_to be_blank }
      check_order_and_term cities
    end

    it 'finds by russian name' do
      term = 'gorod'
      cities = Geo::City.find_by_term(term).to_a
      I18n.locale = :ru
      cities.each { |city| expect(city.name =~ /#{term}/i).not_to be_blank }
      check_order_and_term cities
      I18n.locale = :en
    end
  end

  describe '#translated_text' do
    let(:city) do
      FactoryGirl.create(:city)
    end

    context 'when city has region and country' do
      let(:region) { city.region }
      let(:country) { city.country }

      it 'returns city name with region and country' do
        expect(city.translated_text).to eq(
          [city.translated_name, region.translated_name,
           country.translated_name].join(', ')
        )
        expect(city.translated_text(with_region: false,
                                    locale: I18n.locale,
                                    with_country: true)).to eq(
                                      [city.translated_name,
                                       country.translated_name].join(', ')
                                    )
        expect(city.translated_text(with_country: false,
                                    locale: I18n.locale,
                                    with_region: true)).to eq(
                                      [city.translated_name,
                                       region.translated_name].join(', ')
                                    )
      end
    end

    context 'when city has only country' do
      before do
        city.region_code = nil
        city.save
      end
      let(:country) { city.country }

      it 'returns city name with country' do
        expect(city.translated_text).to eq(
          "#{city.translated_name}, #{country.translated_name}"
        )
      end
    end

    context 'when city has no region and country' do
      before do
        city.region_code = nil
        city.country_code = nil
        city.save
      end

      it 'returns city name' do
        expect(city.translated_text).to eq city.translated_name.to_s
      end
    end
  end
end
