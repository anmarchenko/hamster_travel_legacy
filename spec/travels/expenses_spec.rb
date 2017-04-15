# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Trips::Days do
  def first_day_of(tr)
    tr.reload.days.first
  end

  let(:trip) { FactoryGirl.create(:trip) }
  let(:day) { first_day_of trip }

  describe '#process' do
    context 'when params have day expenses data' do
      let(:params) do
        [{
          name: 'new_expense_name',
          amount_cents: 45_600,
          amount_currency: 'RUB'
        }.with_indifferent_access,
         {
           name: 'new_expense_name_2',
           amount_cents: 9_876_500,
           amount_currency: 'RUB'
         }.with_indifferent_access]
      end

      it 'updates expenses attributes' do
        Trips::Days.save_expenses(day, expenses: params)
        expenses = first_day_of(trip).expenses
        expect(expenses.count).to eq 2
        expect(expenses.first.name).to eq 'new_expense_name'
        expect(expenses.first.amount.to_f).to eq 456.0
        expect(expenses.last.name).to eq 'new_expense_name_2'
        expect(expenses.last.amount.to_f).to eq 98_765.0
      end

      it 'updates expense and removes' do
        Trips::Days.save_expenses(day, expenses: params)
        expenses = first_day_of(trip).expenses

        params = [
          {
            id: expenses.first.id.to_s,
            name: 'updated_name',
            amount_currency: 'EUR'
          }.with_indifferent_access
        ]
        Trips::Days.save_expenses(day, expenses: params)

        updated_expenses = first_day_of(trip).expenses
        expect(updated_expenses.count).to eq 1
        expect(updated_expenses.first.reload.name).to eq 'updated_name'
        expect(updated_expenses.first.reload.amount).to eq(
          Money.new(45_600, 'EUR')
        )
      end

      it 'updates expense when amount is empty' do
        Trips::Days.save_expenses(day, expenses: params)
        expenses = first_day_of(trip).expenses
        params = [
          {
            id: expenses.first.id.to_s,
            name: '',
            amount_cents: '',
            amount_currency: 'EUR'
          }.with_indifferent_access
        ]
        Trips::Days.save_expenses(day, expenses: params)

        updated_expenses = first_day_of(trip).expenses
        expect(updated_expenses.count).to eq 1
        expect(updated_expenses.first.reload.name).to eq ''
        expect(updated_expenses.first.reload.amount).to eq(Money.new(0, 'EUR'))
      end

      it 'removes expenses' do
        Trips::Days.save_expenses(day, expenses: params)
        params = []
        Trips::Days.save_expenses(day, expenses: params)
        updated_day = first_day_of(trip)
        expect(updated_day.expenses.count).to eq 0
      end
    end
  end
end
