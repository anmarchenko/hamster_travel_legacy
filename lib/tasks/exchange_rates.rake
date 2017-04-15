# frozen_string_literal: true
namespace :exchange_rates do
  task :load, [] => :environment do
    LoadExchangeRates.call
    CleanExchangeRates.call
  end
end
