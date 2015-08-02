# == Schema Information
#
# Table name: caterings
#
#  id            :integer          not null, primary key
#  city_code     :string
#  city_text     :string
#  description   :text
#  price         :money
#  days_count    :integer
#  persons_count :integer
#  trip_id       :integer
#

module Travels
  class Catering < ActiveRecord::Base
    belongs_to :trip, class_name: 'Travels::Trip'

    monetize :price_cents
  end
end
