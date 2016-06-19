class Finders::Trips

  def self.search page
    Travels::Trip.where(private: false).where.not(status_code: Travels::Trip::StatusCodes::DRAFT).
      order(status_code: :desc, start_date: :desc).includes(:author_user).page(page || 1)
  end

  def self.for_user user, page
    user.trips.where.not(status_code: Travels::Trip::StatusCodes::DRAFT).order(start_date: :desc).
      includes(:author_user).page(page || 1)
  end

  def self.drafts user, page
    user.trips.where(status_code: Travels::Trip::StatusCodes::DRAFT).
      order(dates_unknown: :asc, start_date: :desc, name: :asc).includes(:author_user).page(page || 1)
  end
end