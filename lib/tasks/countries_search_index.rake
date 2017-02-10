# frozen_string_literal: true
namespace :travel do
  task :countries_search_index, [] => :environment do
    Travels::Trip.all.each(&:regenerate_countries_search_index!)
  end
end
