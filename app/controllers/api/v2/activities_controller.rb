class Api::V2::ActivitiesController < ApplicationController
  before_action :find_trip
  before_action :find_day

  def index
    render  json: @day.as_json(normal_json: true).merge(
        expenses: @day.expenses.as_json,
        activities: @day.activities.as_json,
        links: @day.links.as_json,
        places: @day.places.as_json
    )
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:trip_id]).first
    head 404 and return if @trip.blank?
  end

  def find_day
    @day = @trip.days.where(id: params[:day_id]).first
    head 404 and return if @day.blank?
  end

end