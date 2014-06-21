FactoryGirl.define do
  sequence(:geonames_code) {|n| "#{n}"}
  factory :country, class: 'Geo::Country' do
    geonames_code
    sequence(:name) {"Country #{geonames_code}"}
    sequence(:name_en) {"Country #{geonames_code}"}
    sequence(:name_ru) {"Страна #{geonames_code}"}
    country_code {geonames_code}
    population {200000 + Random.rand(10000000)}

    after (:create) do |country|
      FactoryGirl.create_list(:region, 2, country_code: country.country_code)
      FactoryGirl.create(:city, country_code: country.country_code, status: Geo::City::Statuses::CAPITAL )
    end
  end

  factory :region, class: 'Geo::Region' do
    geonames_code
    sequence(:name) {"Region #{geonames_code}"}
    sequence(:name_en) {"Region #{geonames_code}"}
    sequence(:name_ru) {"Регион #{geonames_code}"}

    region_code {geonames_code}

    population {200000 + Random.rand(10000000)}

    after (:create) do |region|
      FactoryGirl.create_list(:district, 2, country_code: region.country_code, region_code: region.region_code)
      FactoryGirl.create(:city, country_code: region.country_code, region_code: region.region_code,
        status: Geo::City::Statuses::REGION_CENTER )
    end
  end

  factory :district, class: 'Geo::District' do
    geonames_code
    sequence(:name) {"District #{geonames_code}"}
    sequence(:name_en) {"District #{geonames_code}"}
    sequence(:name_ru) {"Район #{geonames_code}"}

    district_code {geonames_code}

    population {200000 + Random.rand(10000000)}

    after (:create) do |district|
      FactoryGirl.create(:city, country_code: district.country_code, region_code: district.region_code,
                         district_code: district.district_code)
    end
  end

  factory :city, class: 'Geo::City' do
    geonames_code
    sequence(:name) {"City #{geonames_code}"}
    sequence(:name_en) {"City #{geonames_code}"}
    sequence(:name_ru) {"Город #{geonames_code}"}

    population {200000 + Random.rand(10000000)}
  end
end