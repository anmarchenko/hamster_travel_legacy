eu_bank = EuCentralBank.new

Money.default_bank = eu_bank

eu_bank.update_rates("#{Rails.root}/lib/ecb_rates.xml")
