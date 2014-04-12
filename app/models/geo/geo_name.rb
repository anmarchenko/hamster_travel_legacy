# not used for now: for future use (multi language project)
module Geo
  class GeoName
    include Mongoid::Document

    field :geonames_id, type: String
    field :locale, type: String

    field :name, type: String

  end
end