# frozen_string_literal: true

module Views
  module ActivityView
    def self.index_json(activities)
      activities.map { |act| show_json(act) }
    end

    def self.show_json(activity)
      activity.as_json(except: :day_id)
              .merge(
                'id' => activity.id.to_s,
                'amount_currency_text' => activity.amount.currency.symbol
              )
    end
  end
end
