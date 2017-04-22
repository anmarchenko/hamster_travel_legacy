# frozen_string_literal: true

module UserProfile
  def self.list_next_planned_trips(user, current_user)
    user.trips.relevant.visible_by(current_user)
        .planned
        .order_oldest
        .limit(3).includes(:cities)
  end

  def self.list_last_finished_trips(user, current_user)
    user.trips.relevant.visible_by(current_user)
        .finished
        .order_newest
        .limit(3).includes(:cities)
  end
end
