module Geo
  class District

    include Mongoid::Document
    include Concerns::Geographical

  end
end