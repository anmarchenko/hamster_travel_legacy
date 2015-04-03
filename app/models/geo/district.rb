module Geo
  class District < ActiveRecord::Base

    include Concerns::Geographical

  end
end