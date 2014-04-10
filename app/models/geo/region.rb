module Geo
  class Region

    include Mongoid::Document
    include Concerns::Geographical

  end
end