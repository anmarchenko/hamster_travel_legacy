# frozen_string_literal: true

module Trips
  module Expenses
    def self.list(expendable)
      expendable.expenses
    end
  end
end
