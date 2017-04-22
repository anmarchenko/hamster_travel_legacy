# frozen_string_literal: true

module Views
  module ExpenseView
    def self.index_json(expenses)
      expenses.map { |ex| show_json(ex) }
    end

    def self.show_json(expense)
      expense.as_json
             .merge(
               'id' => expense.id.to_s,
               'amount_currency_text' => expense.amount.currency.symbol
             )
    end
  end
end
