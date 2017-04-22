# frozen_string_literal: true

module Trips
  module Activities
    def self.list(day)
      day.activities.ordered
    end

    def self.top(day, opts = { limit: 3 })
      day.activities.order(rating: :desc, order_index: :asc)
         .first(opts[:limit])
    end
  end
end
