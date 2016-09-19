module Finders
  module Trips
    module_function

    def search(term, user = nil)
      query = Travels::Trip.all
      query = restrict_query(query, user)
      query = query.where('name ILIKE ? OR countries_search_index ILIKE ?', "%#{term}%", "%#{term}%") if term.present?
      query = query.order(start_date: :desc)
      query
    end

    def all(page)
      Travels::Trip.where(private: false).where.not(status_code: Travels::Trip::StatusCodes::DRAFT).
          order(status_code: :desc, start_date: :desc).page(page || 1)
    end

    def for_user(user, page)
      user.trips.where.not(status_code: Travels::Trip::StatusCodes::DRAFT).order(start_date: :desc).
          page(page || 1)
    end

    def for_user_planned(user, page, current_user)
      query = user.trips.where(status_code: Travels::Trip::StatusCodes::PLANNED).order(start_date: :asc).
        page(page || 1).per(9)
      query = query.where(private: false) unless user == current_user
      query
    end

    def for_user_finished(user, page, current_user)
      query = user.trips.where(status_code: Travels::Trip::StatusCodes::FINISHED).order(start_date: :desc).
        page(page || 1).per(9)
      query = query.where(private: false) unless user == current_user
      query
    end

    def drafts(user, page)
      user.trips.where(status_code: Travels::Trip::StatusCodes::DRAFT).
          order(dates_unknown: :asc, start_date: :desc, name: :asc).page(page || 1)
    end

    def restrict_query(query, user)
      if user.present?
        query.where.not(status_code: Travels::Trip::StatusCodes::DRAFT).where(private: false).or(
          Travels::Trip.where(id: user.trip_ids)
        )
      else
        query.where.not(status_code: Travels::Trip::StatusCodes::DRAFT).where(private: false)
      end
    end
  end
end
