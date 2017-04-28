# frozen_string_literal: true

module Views
  module ActivityView
    def self.index_json(activities, current_user = nil)
      activities.map { |act| show_json(act, current_user) }
    end

    def self.show_json(activity, current_user = nil)
      activity.as_json(except: :day_id)
              .merge(
                'id' => activity.id.to_s
              ).merge(
                Views::AmountView.show_json(activity.amount, current_user)
              )
    end
  end
end
