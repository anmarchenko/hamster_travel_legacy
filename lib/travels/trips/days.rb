# frozen_string_literal: true

module Trips
  module Days
    extend Common::EntityUpdater

    DEPENDENCIES = {
      transfers: { transfers: %i[links city_from city_to] },
      hotel: { hotel: :links },
      places: { places: { city: :translations } },
      expenses: :expenses,
      activities: :activities,
      links: :links
    }.freeze

    # READ ACTIONS
    def self.list(trip, nested_associations = nil)
      trip.days.includes(*nested_associations.map { |asc| DEPENDENCIES[asc] })
    end

    def self.top_activities(day, opts = { limit: 3 })
      day.activities
         .unscoped
         .where(day_id: day.id)
         .order(rating: :desc, order_index: :asc)
         .first(opts[:limit])
    end

    # UPDATE ACTIONS
    def self.update_day(trip, day, params)
      save_activities(day, params)
      save_expenses(day, params)
      save_links(day, params)
      save_places(day, params)
      save_hotel(day, params)
      save_transfers(day, params)
      save(day, params)
      day.save
      Budgets.on_budget_change(trip)
    end

    def self.save(day, attrs)
      return unless attrs.key?(:comment)
      day.update_attributes(comment: attrs[:comment])
    end

    def self.save_links(day, params)
      return unless params.key?(:links)
      save_nested(day.links, params[:links])
    end

    def self.save_activities(day, params)
      return unless params.key?(:activities)
      activities_params = order_params(
        reject_empty_activities(params[:activities])
      )
      save_nested(day.activities, activities_params)
    end

    def self.save_expenses(day, params)
      return unless params.key?(:expenses)
      save_nested(day.expenses, params[:expenses])
    end

    def self.save_places(day, params)
      return unless params.key?(:places)
      save_nested(day.places, params[:places])
      Trips.on_places_update(day.trip)
    end

    def self.save_hotel(day, params)
      return unless params.key?(:hotel)
      save_nested(day.hotel.links, params[:hotel][:links])
      hotel_params = fix_amount(params[:hotel].except(:links))
      day.hotel.update_attributes(hotel_params)
    end

    def self.save_transfers(day, params)
      return unless params.key?(:transfers)
      transfers_params = order_params(params[:transfers])
      save_nested(day.transfers, transfers_params, ['links'])
    end

    # EVENTS
    def self.on_trip_update(trip)
      Trips::Days::Number.normalize(trip)
    end

    # INTERNAL ACTIONS
    def self.reject_empty_activities(acts)
      acts.delete_if { |act| act['name'].blank? } || []
    end
  end
end
