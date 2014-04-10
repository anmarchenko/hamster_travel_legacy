module Geo
  class City

    include Mongoid::Document
    include Concerns::Geographical

    module Statuses
      CAPITAL = 'capital'
      REGION_CENTER = 'region_center'
      DISTRICT_CENTER = 'district_center'
      ADM3_CENTER = 'adm3_center'
      ADM4_CENTER = 'adm4_center'
      ADM5_CENTER = 'adm5_center'
    end

    field :status, type: String

    def is_capital?
      status == Statuses::CAPITAL
    end

    def is_region_center?
      status == Statuses::REGION_CENTER
    end

    def is_district_center?
      status == Statuses::DISTRICT_CENTER
    end

    def is_adm3_center?
      status == Statuses::ADM3_CENTER
    end

    def is_adm4_center?
      status == Statuses::ADM4_CENTER
    end

    def is_adm5_center?
      status == Statuses::ADM5_CENTER
    end

  end
end