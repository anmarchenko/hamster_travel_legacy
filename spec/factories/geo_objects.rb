FactoryGirl.define do
  sequence(:geonames_code, &:to_s)

  factory :country, class: 'Geo::Country' do
    geonames_code

    country_code { geonames_code }
    iso_code { geonames_code }
    iso3_code { geonames_code }
    population { 200_000 + Random.rand(10_000_000) }

    after(:create) do |country|
      # translations
      country.translations.create(name: "Country #{country.geonames_code}", locale: :en)
      country.translations.create(name: "Strana #{country.geonames_code}", locale: :ru)

      # dependent geo objects
      FactoryGirl.create_list(:region, 2, country_code: country.country_code)
      FactoryGirl.create(:city, country_code: country.country_code, status: Geo::City::Statuses::CAPITAL)
    end
  end

  factory :region, class: 'Geo::Region' do
    geonames_code

    region_code { geonames_code }

    population { 200_000 + Random.rand(10_000_000) }

    after(:create) do |region|
      # translations
      region.translations.create(name: "Region #{region.geonames_code}", locale: :en)
      region.translations.create(name: "Oblast #{region.geonames_code}", locale: :ru)

      # dependent geo objects
      FactoryGirl.create_list(:district, 2, country_code: region.country_code, region_code: region.region_code)
      FactoryGirl.create(:city, country_code: region.country_code, region_code: region.region_code,
                                status: Geo::City::Statuses::REGION_CENTER)
    end
  end

  factory :district, class: 'Geo::District' do
    geonames_code

    district_code { geonames_code }

    population { 200_000 + Random.rand(10_000_000) }

    after(:create) do |district|
      # translations
      district.translations.create(name: "District #{district.geonames_code}", locale: :en)
      district.translations.create(name: "Rayon #{district.geonames_code}", locale: :ru)

      # dependent geo objects
      FactoryGirl.create(:city, country_code: district.country_code, region_code: district.region_code,
                                district_code: district.district_code)
    end
  end

  factory :city, class: 'Geo::City' do
    geonames_code

    population { 200_000 + Random.rand(10_000_000) }

    longitude { Random.rand * 1000 }
    latitude { Random.rand * 1000 }

    after :create do |city|
      # translations
      city.translations.create(name: "City #{city.geonames_code}", locale: :en)
      city.translations.create(name: "Gorod #{city.geonames_code}", locale: :ru)
    end
  end
end
