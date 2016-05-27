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
        'prepCountries' => Geo::Country,
        'prepRegions' => Geo::Region,
        'prepDistricts' => Geo::District,
        'prepAdm3' => Geo::Adm3,
        'prepAdm4' => Geo::Adm4,
        'prepAdm5' => Geo::Adm5,
        'prepCities' => Geo::City
    }
  end

  def self.find_by_geonames_code code
    Geo::City.by_geonames_code(code) ||
        Geo::Adm5.by_geonames_code(code) ||
        Geo::Adm4.by_geonames_code(code) ||
        Geo::Adm3.by_geonames_code(code) ||
        Geo::District.by_geonames_code(code) ||
        Geo::Region.by_geonames_code(code) ||
        Geo::Country.by_geonames_code(code)
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

    # migrate models
    geo_models.each do |file_name, klass|
      File.open("#{PATH_TO_DATA}/#{file_name}") do |f|
        puts "Processing file #{file_name}"
        number = 0
        f.each_line do |line|
          number += 1

          object = klass.create
          object.update_from_geonames_string(line)

          puts "Line #{number}" if number % 100 == 0
        end
      end
    end

    # migrate country info
    File.open("#{PATH_TO_DATA}/countryInfo.txt") do |f|
      f.each_line do |line|
        next if line.start_with?('#')
        values = Geo::Country.split_geonames_string line
        object = Geo::Country.where(geonames_code: values[16].strip).first
        if object.blank?
          puts "ERROR!! Country #{values[0]} not found"
          next
        end
        object.load_additional_info(line)
      end
    end

    # alternate names
    File.open("#{PATH_TO_DATA}/alternateNames.txt") do |f|
      f.each_line do |line|
        values = Geo::Country.split_geonames_string line
        next unless %w(en ru).include? values[2]
        object = find_by_geonames_code(values[1])
        if object.blank?
          puts "ERROR!! Object #{values[1]} not found"
          next
        end
        object.send("name_#{values[2]}=", values[3])
        object.save
        puts "Processed #{values[3]} for #{object}"
      end
    end

  end

end
