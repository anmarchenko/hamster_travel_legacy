# -*- encoding: utf-8 -*-
namespace :geo do

  desc 'geonames'

  PATH_TO_DATA = '/var/data'

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
  def self.geo_models
    {
        #'prepCountries' => Geo::Country,
        #'prepRegions' => Geo::Region,
        #'prepDistricts' => Geo::District,
        #'prepAdm3' => Geo::Adm3,
        #'prepAdm4' => Geo::Adm4,
        #'prepAdm5' => Geo::Adm5,
        'prepCities' => Geo::City
    }
  end

  task :prepare, [] => :environment do

    outputFiles = {}
    DATA_FILES.each do |file_name|
      outputFiles[file_name] = File.open("#{PATH_TO_DATA}/#{file_name}", 'w+')
    end

    # read all countries
    File.open("#{PATH_TO_DATA}/allCountries.txt") do |f|
      f.each_line do |line|
        arr = Geo::Country.split_geonames_string(line)

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
    geo_models.each {|key, klass| klass.delete_all}

    # migrate countries
    geo_models.each do |file_name, klass|
      File.open("#{PATH_TO_DATA}/#{file_name}") do |f|
        f.each_line do |line|
          object = klass.create
          object.update_from_geonames_string(line)
        end
      end
    end
  end

end
