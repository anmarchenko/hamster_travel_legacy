# frozen_string_literal: true

module Views
  module CateringView
    def self.index_json(caterings, current_user = nil)
      caterings.map { |catering| show_json(catering, current_user) }
    end

    def self.show_json(catering, current_user = nil)
      catering.as_json.merge(
        Views::AmountView.show_json(catering.amount, current_user)
      )
    end
  end
end
