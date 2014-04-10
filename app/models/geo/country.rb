module Geo
  class Country

    include Mongoid::Document
    include Concerns::Geographical

    field :iso_code, type: String
    field :iso3_code, type: String
    field :iso_numeric_code, type: String

    field :area, type: Integer

    field :currency_code, type: String
    field :currency_text, type: String

    field :languages, type: Array

  end
end