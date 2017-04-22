# frozen_string_literal: true

module Authorization
  def self.can_be_seen?(trip, user)
    !trip.private || trip.include_user(user)
  end
end
