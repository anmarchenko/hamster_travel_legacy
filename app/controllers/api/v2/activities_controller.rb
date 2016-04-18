class Api::V2::ActivitiesController < ApplicationController
  before_action :find_trip
  before_action :find_day
  before_action :authenticate_user!, only: [:create, :update]
  before_action :authorize, only: [:create, :update]

  def index
    render json: @day.as_json(normal_json: true).merge(
        expenses: @day.expenses.as_json,
        activities: @day.activities.as_json,
        links: @day.links.as_json,
        places: @day.places.as_json
    )
  end

  def create
    prms = day_params
    Updaters::Activities.new(@day, prms.delete(:activities)).process
    Updaters::DayExpenses.new(@day, prms.delete(:expenses)).process
    Updaters::DayLinks.new(@day, prms.delete(:links)).process
    Updaters::DayPlaces.new(@day, prms.delete(:places)).process
    Updaters::Day.new(@day, prms).process
    render json: {status: 0}
  end

  private

  def day_params
    params.require(:day).permit(
        :comment,
        activities: [
            :id, :name, :comment, :link_description, :amount_cents, :amount_currency
        ],
        links: [
            :id, :description, :url
        ],
        expenses: [
            :id, :name, :amount_cents, :amount_currency
        ],
        places: [
            :id, :city_id
        ]
    )
  end

  def authorize
    head 403 and return if !@trip.include_user(current_user)
  end

  def find_trip
    @trip = Travels::Trip.where(id: params[:trip_id]).first
    head 404 and return if @trip.blank?
  end

  def find_day
    @day = @trip.days.where(id: params[:day_id]).first
    head 404 and return if @day.blank?
  end

end