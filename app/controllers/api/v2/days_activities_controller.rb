class Api::V2::DaysActivitiesController < ApplicationController
  before_action :find_trip
  before_action :authenticate_user!, only: [:create]
  before_action :authorize!, only: [:create]

  def index
    render json: {
        days: @trip.days.includes(:expenses, :activities, :links, :places)
                  .as_json(normal_json: true, include: [:expenses, :activities, :links, :places])
    }
  end

  def create
    prms = days_params
    (prms[:days] || []).each do |day_params|
      day = @trip.days.where(id: day_params.delete(:id)).first
      Updaters::Activities.new(day, day_params.delete(:activities)).process
      Updaters::DayExpenses.new(day, day_params.delete(:expenses)).process
      Updaters::DayLinks.new(day, day_params.delete(:links)).process
      Updaters::DayPlaces.new(day, day_params.delete(:places)).process
      Updaters::Day.new(day, day_params).process
    end
    render json: {status: 0}
  end

  private

  def days_params
    params.permit(days:
                      [
                          :id,
                          :comment,
                          {
                              activities: [
                                  :id, :name, :comment, :link_url, :amount_cents, :amount_currency, :rating, :address, :working_hours
                              ]
                          },
                          {
                              links: [
                                  :id, :description, :url
                              ]
                          },
                          {
                              expenses: [
                                  :id, :name, :amount_cents, :amount_currency
                              ]
                          },
                          {
                              places: [
                                  :id, :city_id
                              ]
                          }
                      ]
    )
  end


  def find_trip
    @trip = Travels::Trip.where(id: params[:trip_id]).first
    head 404 and return if @trip.blank?
  end

  def authorize!
    head 403 and return if !@trip.include_user(current_user)
  end

end