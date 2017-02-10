# frozen_string_literal: true
cache = "#{Rails.root}/lib/ecb_rates.xml"

eu_bank = EuCentralBank.new
Money.default_bank = eu_bank

p 'Loading exchange rates from ECB local...'
eu_bank.update_rates(cache)
p 'Exchange rates are loaded.'
