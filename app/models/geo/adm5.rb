# == Schema Information
#
# Table name: adm5s
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
#  mongo_id                   :string
#

module Geo
  class Adm5 < ActiveRecord::Base

    include Concerns::Geographical

    translates :name, :fallbacks_for_empty_translations => true

    def self.find_by_term(term)
      term = Regexp.escape(term)
      self.all.with_translations.where("\"adm5_translations\".\"name\" ILIKE ?", "#{term}%").order(population: :desc)
    end

  end
end
