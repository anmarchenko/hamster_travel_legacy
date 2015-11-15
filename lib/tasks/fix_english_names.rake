# -*- encoding: utf-8 -*-
namespace :geo do


  task :fix_english_names, [] => :environment do
    GEO_OBJECTS = [Geo::Country,
                   Geo::Region,
                   Geo::District,
                   Geo::Adm3,
                   Geo::Adm4,
                   Geo::Adm5,
                   Geo::City]

    # GEO_OBJECTS.each do |klass|
    #   p "Fixing #{klass}..."
    #   started = Time.now
    #
    #   klass.all.each do |object|
    #     object.update_attributes(name_en: object.name)
    #   end
    #   GC.start
    #
    #   p "Finished fixing #{klass} in #{Time.now - started} seconds."
    # end

    Geo::Country.all.each do |country|
      iso_country_info = country.iso_info
      if iso_country_info.blank?
        p "Country not found: #{country.iso_code}, #{country.name}"
        next
      end

      country.update_attributes(name: iso_country_info.translation, name_en: iso_country_info.translation)
    end
  end

end
