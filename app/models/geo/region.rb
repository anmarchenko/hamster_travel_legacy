module Geo
  class Region < ActiveRecord::Base

    include Concerns::Geographical

  end
end