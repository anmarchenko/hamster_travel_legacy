class Api::DaysSortingController < ApplicationController
  before_action :find_trip
  before_action :authenticate_user!
  before_action :authorize

  respond_to :json

  def index
    respond_with @trip.days.map { |day| day.short_hash }
  end

  def create
    @trip.days.index_by(&:id).slice(*array_of_ids).values
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:trip_id]).first
    head 404 and return if @trip.blank?
  end

  def authorize
    head 403 and return if !@trip.include_user(current_user)
  end

end