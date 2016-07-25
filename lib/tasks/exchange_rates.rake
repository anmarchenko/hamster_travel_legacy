namespace :exchange_rates do
  task :load, [] => :environment do
    LoadExchangeRates.call
  end

  task :clean, [] => :environment do
    CleanExchangeRates.call
  end
end
