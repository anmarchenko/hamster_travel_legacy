# -*- encoding: utf-8 -*-
namespace :geo do

  desc 'geonames'

  PATH_TO_DATA = '/home/andrey/Data'
  DATA_FILES = %w(prepCountries prepRegions prepDistricts prepAdm3 prepAdm4 prepAdm5 prepCities)
  FEATURE_CODE_TO_FILE = {
      'ADM1' => 'prepRegions',
      'ADM2' => 'prepDistricts',
      'ADM3' => 'prepAdm3',
      'ADM4' => 'prepAdm4',
      'ADM5' => 'prepAdm5',
      'PCL' => 'prepCountries',
      'PCLD' => 'prepCountries',
      'PCLF' => 'prepCountries',
      'PCLI' => 'prepCountries',
      'PCLS' => 'prepCountries'
  }

  task :prepare, [] => :environment do

    outputFiles = {}
    DATA_FILES.each do |file_name|
      outputFiles[file_name] = File.open("#{PATH_TO_DATA}/#{file_name}", 'w+')
    end

    # read all countries
    File.open("#{PATH_TO_DATA}/allCountries.txt") do |f|
      f.each_line do |line|
        arr = line.split(/\t/)

        feature_class = arr[6]
        feature_code = arr[7]

        case feature_class
          when 'A'
            file = FEATURE_CODE_TO_FILE[feature_code]
            outputFiles[ file ].write(line) unless file.blank?
          when 'P'
            outputFiles['prepCities'].write(line)
        end
      end
    end

    p 'Close all files...'

    outputFiles.each { |k, v| v.close() }

    p 'Finished task.'
  end

  task :migrate, [] => :environment do
  end

end
