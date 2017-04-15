# frozen_string_literal: true

module Finders
  module Trips
    module_function

    def for_user(user, page)
      user.trips.relevant
          .where.not(status_code: ::Trips::StatusCodes::DRAFT)
          .order(start_date: :desc)
          .page(page || 1)
    end

    def for_user_planned(user, page, current_user)
      query = user.trips.relevant
                  .where(status_code: ::Trips::StatusCodes::PLANNED)
                  .order(start_date: :asc)
                  .page(page || 1)
                  .per(9)
      query = query.where(private: false) unless user == current_user
      query
    end

    def for_user_finished(user, page, current_user)
      query = user
              .trips.relevant
              .where(status_code: ::Trips::StatusCodes::FINISHED)
              .order(start_date: :desc)
              .page(page || 1)
              .per(9)
      query = query.where(private: false) unless user == current_user
      query
    end

    def drafts(user, page)
      user.trips.relevant
          .where(status_code: ::Trips::StatusCodes::DRAFT)
          .order(dates_unknown: :asc, start_date: :desc, name: :asc)
          .page(page || 1)
    end
  end
end
