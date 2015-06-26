class AddPriceToExpenses < ActiveRecord::Migration
  def change
    add_monetize :expenses, :amount
    Travels::Expense.reset_column_information

    Travels::Expense.all.each do |expense|
      expense.update_attributes(amount_cents: expense.price * 100) unless expense.price.blank?
    end
  end
end
