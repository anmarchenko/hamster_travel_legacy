# frozen_string_literal: true

module Views
  module BudgetView
    def self.show_json(budget)
      {
        budget: {
          sum: budget.sum,
          transfers_hotel_budget: budget.transfers_hotel,
          activities_other_budget: budget.activities_other,
          catering_budget: budget.catering,
          budget_for: budget.people_count
        }
      }
    end
  end
end
