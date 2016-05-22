class Api::V2::DaysTransfersController < ApplicationController
  before_action :find_trip

  def index
    render json: {
        days: @trip.days.includes(:transfers, :hotel, :places)
                  .as_json(normal_json: true, include: [:transfers, :hotel, :places])
    }
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:trip_id]).first
    head 404 and return if @trip.blank?
  end

  def authorize!
    head 403 and return if !@trip.include_user(current_user)
  end

end