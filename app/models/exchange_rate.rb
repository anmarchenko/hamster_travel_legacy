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

  def self.current
    order(rates_date: :desc, created_at: :desc).first
  end

end
