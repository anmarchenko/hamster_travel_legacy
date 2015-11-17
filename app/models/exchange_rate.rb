# == Schema Information
#
# Table name: exchange_rates
#
#  id         :integer          not null, primary key
#  eu_file    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rates_date :date
#

class ExchangeRate < ActiveRecord::Base
end
