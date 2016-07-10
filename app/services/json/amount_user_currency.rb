class Json::AmountUserCurrency
  attr_accessor :user_currency

  def initialize user_currency
    self.user_currency = user_currency
  end

  def call target
    return if self.user_currency.blank?
    return if target.blank?
    if target.is_a?(Array)
      target.each { |obj| process_object(obj) }
    else
      process_object(target)
    end
  end

  private

  def process_object object
    if object['amount_cents'].present? && object['amount_currency'].present? && object['amount_currency'] != user_currency
      amount = Money.new(object['amount_cents'], object['amount_currency']).exchange_to(user_currency)
      object['in_user_currency'] = {amount_cents: amount.cents, amount_currency_text: amount.currency.symbol}
    end
  end

end