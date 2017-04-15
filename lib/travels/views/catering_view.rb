# frozen_string_literal: true

module Views
  module CateringView
    def self.index_json(caterings, user = nil)
      caterings.map { |catering| show_json(catering, user) }
    end

    def self.show_json(catering, user = nil)
      Views::Decorators::AmountInUserCurrency.decorate(
        catering.as_json,
        user&.currency
      )
    end
  end
end
