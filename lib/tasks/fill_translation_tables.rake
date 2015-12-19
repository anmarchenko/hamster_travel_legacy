# -*- encoding: utf-8 -*-
namespace :geo do

  task :fill_translation_tables, [] => :environment do
    GEO_OBJECTS = [
        Geo::Country,
        Geo::Region,
        Geo::District,
        Geo::Adm3,
        Geo::Adm4,
        Geo::Adm5,
        Geo::City
    ]

    GEO_OBJECTS.each do |klass|
      p "Translating #{klass}..."
      started = Time.now
      klass.find_each do |object|
        object.translations.create(name: object.name, locale: :en)
        object.translations.create(name: object.name_ru, locale: :ru)
        p "."
      end
      p "Finished fixing #{klass} in #{Time.now - started} seconds."
    end
  end

end
