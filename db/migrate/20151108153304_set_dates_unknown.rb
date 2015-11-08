class SetDatesUnknown < ActiveRecord::Migration
  def change
    Travels::Trip.all.each {|trip| trip.update_attributes(dates_unknown: false) if trip.dates_unknown.nil? }
  end
end
