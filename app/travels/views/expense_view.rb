# frozen_string_literal: true

module Views
  module ExpenseView
    def self.index_json(expenses, current_user = nil)
      expenses.map { |ex| show_json(ex, current_user) }
    end

    def self.show_json(expense, current_user = nil)
      expense.as_json
             .merge(
               'id' => expense.id.to_s
             ).merge(
               Views::AmountView.show_json(expense.amount, current_user)
             )
    end
  end
end
