# -*- encoding: utf-8 -*-
namespace :geo do

  desc 'geonames'

  PATH_TO_DATA = '~/Data'

  task :prepare, [] => :environment do

    File.open("#{PATH_TO_DATA}/allCountries.txt")

  end

  task :migrate, [] => :environment do
  end

end
