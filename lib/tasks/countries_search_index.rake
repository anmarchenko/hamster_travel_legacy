namespace :travel do
  task :countries_search_index, [] => :environment do
    Travels::Trip.all.each do |trip|
      trip.regenerate_countries_search_index!
    end
  end
end
