eu_bank = EuCentralBank.new

Money.default_bank = eu_bank

p "Loading exchange rates from ECB..."
eu_bank.update_rates("#{Rails.root}/lib/ecb_rates.xml")
p "Exchange rates loaded."