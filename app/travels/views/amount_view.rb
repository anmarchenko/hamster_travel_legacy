# frozen_string_literal: true

module Views
  module AmountView
    def self.show_json(amount, current_user = nil)
      currency_s = amount.currency.symbol
      amount_hash_with_user_currency(
        {
          'amount_s' => format("%.2f #{currency_s}", amount.to_f),
          'amount_cents' => Amounts.to_frontend(amount),
          'amount_currency_text' => currency_s
        },
        amount,
        current_user&.currency
      )
    end

    def self.amount_hash_with_user_currency(hash, amount, user_currency)
      return hash if !user_currency || user_currency == amount.currency
      hash.merge(
        'in_user_currency' => show_json(amount.exchange_to(user_currency))
      )
    end
  end
end
