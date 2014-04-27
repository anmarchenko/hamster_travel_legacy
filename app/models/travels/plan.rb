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
      (days_count - self.days.length).times do
        date = self.days.last.try(:date_when)
        if date.blank?
          date = trip.start_date
        else
          date = date + 1.day
        end
        self.days.create(plan: self, date_when: date)
      end
    end

  end
end