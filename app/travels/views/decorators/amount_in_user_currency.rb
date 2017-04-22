# frozen_string_literal: true

module Views
  module Decorators
    module AmountInUserCurrency
      def self.decorate(target, user_currency, nested_objects = [])
        return target if user_currency.blank?
        return target if target.blank?
        if target.is_a?(Array)
          target.map { |obj| decorate_object(obj, user_currency) }
        else
          decorate_object(target, user_currency, nested_objects)
        end
      end

      def self.decorate_object(object, user_currency, nested_objects = [])
        object = decorate_nested(object, user_currency, nested_objects)
        if amount?(object) && object['amount_currency'] != user_currency
          object.merge(
            'in_user_currency' => in_user_currency(
              object['amount_cents'], object['amount_currency'], user_currency
            )
          )
        else
          object
        end
      end

      def self.decorate_nested(object, user_currency, nested_objects = [])
        return object if nested_objects.blank?
        nested_objects.reduce(object) do |object_acc, nested_field|
          object_acc.merge(
            nested_field.to_s => decorate(
              object[nested_field.to_s], user_currency
            )
          )
        end
      end

      def self.amount?(object)
        object['amount_cents'].present? && object['amount_currency'].present?
      end

      def self.in_user_currency(amount_cents, currency, user_currency)
        amount_in_user_currency = Money.new(amount_cents, currency)
                                       .exchange_to(user_currency)
        {
          amount_cents: amount_in_user_currency.cents,
          amount_currency_text: amount_in_user_currency.currency.symbol
        }
      end
    end
  end
end
