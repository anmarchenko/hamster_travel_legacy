# frozen_string_literal: true

module UserTrips
  def self.list_trips(user, page)
    user.trips.relevant
        .not_drafts.order_newest
        .page(page || 1)
        .includes(:author_user, :cities)
  end

  def self.list_drafts(user, page)
    user.trips.relevant
        .drafts
        .order_with_dates.order_newest.order_alpha
        .page(page || 1)
        .includes(:author_user, :cities)
  end
end
