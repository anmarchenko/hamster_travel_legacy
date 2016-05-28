class Finders::Trips

  attr_accessor :user, :page

  def initialize user, page
    self.user = user
    self.page = page
  end

  def index show_user_trips = nil, show_user_drafts = nil
    return all_trips unless user
    if show_user_trips
      user_trips
    elsif show_user_drafts
      user_drafts
    else
      all_trips
    end
  end

  def all_trips
    post_process(Travels::Trip.where(private: false).where.not(status_code: Travels::Trip::StatusCodes::DRAFT).
        order(status_code: :desc, start_date: :desc))
  end

  def user_trips
    post_process(user.trips.where.not(status_code: Travels::Trip::StatusCodes::DRAFT).order(start_date: :desc))
  end

  def user_drafts
    post_process(user.trips.where(status_code: Travels::Trip::StatusCodes::DRAFT).
        order(dates_unknown: :asc, start_date: :desc, name: :asc))

  end

  private

  def post_process trips
    trips.includes(:author_user).page(page || 1)
  end
end