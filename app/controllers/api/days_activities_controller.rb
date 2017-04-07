# frozen_string_literal: true

module Api
  class DaysActivitiesController < ApplicationController
    before_action :find_trip
    before_action :authenticate_user!, only: [:create]
    before_action :authorize!, only: [:create]
    before_action :api_authorize_readonly!, only: [:index]

    def index
      render json: {
        days: @trip.days.includes(
          :expenses, :activities, :links, places: { city: :translations }
        ).as_json(user_currency: current_user.try(:currency),
                  include: %i[expenses activities links places])
      }
    end

    def create
      days_params[:days].each { |day_params| process_day(day_params) }
      Calculators::Budget.new(@trip).invalidate_cache!
      render json: { status: 0 }
    end

    private

    def process_day(day_params)
      day = @trip.days.where(id: day_params.delete(:id)).first
      Updaters::Activities.new(day, day_params.delete(:activities)).process
      Updaters::DayExpenses.new(day, day_params.delete(:expenses)).process
      Updaters::DayLinks.new(day, day_params.delete(:links)).process
      Updaters::DayPlaces.new(day, day_params.delete(:places)).process
      Updaters::Day.new(day, day_params).process
    end

    def days_params
      params.permit(days:
                        [
                          :id,
                          :comment,
                          {
                            activities: %i[
                              id name comment link_url amount_cents
                              amount_currency rating address
                              working_hours
                            ]
                          },
                          {
                            links: %i[id description url]
                          },
                          {
                            expenses: %i[
                              id name amount_cents amount_currency
                            ]
                          },
                          {
                            places: %i[id city_id]
                          }
                        ])
    end

    def find_trip
      @trip = Travels::Trip.where(id: params[:trip_id]).first
      head(404) && return if @trip.blank?
    end

    def authorize!
      head(403) && return unless @trip.include_user(current_user)
    end
  end
end
