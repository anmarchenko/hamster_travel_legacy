# -*- encoding: utf-8 -*-
# frozen_string_literal: true
namespace :travel do
  task :fill_city_ids, [] => :environment do
    p "Filling #{Travels::Place}..."
    started = Time.now
    Travels::Place.find_each do |object|
      next if object.city.blank?
      object.city_id = object.city.id
      object.save
    end
    p "Finished fixing #{Travels::Place} in #{Time.now - started} seconds."

    p "Filling #{Travels::Transfer}..."
    started = Time.now
    Travels::Transfer.find_each do |object|
      next if object.city_from.blank? || object.city_to.blank?
      object.city_from_id = object.city_from.id
      object.city_to_id = object.city_to.id
      object.save
    end
    p "Finished fixing #{Travels::Transfer} in #{Time.now - started} seconds."

    p "Filling #{User}..."
    started = Time.now
    User.find_each do |object|
      next if object.home_town.blank?
      object.home_town_id = object.home_town.id
      object.save
    end
    p "Finished fixing #{User} in #{Time.now - started} seconds."
  end
end
