class Api::V2::DaysTransfersController < ApplicationController
  before_action :find_trip
  before_action :authenticate_user!, only: [:create]
  before_action :authorize!, only: [:create]

  def index
    render json: {
        days: @trip.days.includes(:transfers, :hotel, :places)
                  .as_json(normal_json: true, include: [:transfers, :hotel, :places])
    }
  end

  def create
    prms = days_params
    (prms[:days] || []).each do |day_params|
      p day_params
      day = @trip.days.where(id: day_params.delete(:id)).first
      Updaters::Transfers.new(day, day_params.delete(:transfers)).process
      Updaters::DayPlaces.new(day, day_params.delete(:places)).process
      Updaters::Hotel.new(day, day_params.delete(:hotel)).process
    end
    render json: {status: 0}
  end

  private

  def days_params
    params.permit(days:
                      [
                          :id,
                          {
                              transfers: [
                                  :id, :name, :comment, :link_url, :amount_cents, :amount_currency, :rating, :address, :working_hours
                              ]
                          },
                          {
                              hotel: [
                                  :id, :description, :url
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