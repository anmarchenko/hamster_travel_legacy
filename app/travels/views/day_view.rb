# frozen_string_literal: true

module Views
  module DayView
    def self.index_json(days, nested_objects = [], user = nil)
      days.map do |day|
        show_json(day, nested_objects, user)
      end
    end

    def self.show_json(day, nested_objects = [], user = nil)
      Views::Decorators::DaysNestedFields.decorate(
        day.as_json,
        day,
        nested_objects,
        user
      )
    end

    def self.reordering_index(days)
      days.map do |day|
        reordering_show(day)
      end
    end

    def self.reordering_show(day)
      {
        id: day.id.to_s,
        date: day.date_when,
        index: day.index,
        transfer_s: reordering_info_transfers(day),
        activity_s: reordering_info_activities(day),
        place_s: reordering_info_places(day),
        day_info_s: reordering_info_day(day)
      }
    end

    def self.reordering_info_activities(day)
      res = ''
      Trips::Activities.top(day).each_with_index do |activity, index|
        res += "#{index + 1}. #{activity.name}"
        res += '<br/>'
      end
      res
    end

    def self.reordering_info_transfers(day)
      transfer = Trips::Transfers.list(day).first
      "#{transfer.city_from_text} - #{transfer.city_to_text}" if transfer
    end

    def self.reordering_info_places(day)
      place = Trips::Places.list(day).first
      place&.city_text
    end

    def self.reordering_info_day(day)
      expense = Trips::Expenses.list(day).first
      if expense.present? && !expense.empty_content?
        return "#{expense.name} #{expense.amount.to_f}" \
               " #{expense.amount.currency.symbol}"
      end
      link = Trips::Links.list_day(day).first
      link&.description
    end
  end
end
