module Travels
  class Plan
    include Mongoid::Document

    embedded_in :trip, class_name: 'Travels::Trip'

    field :name
    embeds_many :days, class_name: 'Travels::Day'

    def update_plan
      self.days ||= []
      days_count = (trip.end_date - trip.start_date).to_i + 1
      (self.days[days_count..-1] || []).each { |day| day.destroy }
      self.days.each_with_index do |day, index|
        day.date_when = (trip.start_date + index.days)
        day.save
      end
      (days_count - self.days.length).times { self.days.create(plan: self, date_when: (self.days.last.date_when + 1.day) ) }
    end

  end
end