# frozen_string_literal: true
module Api
  class DaysTransfersController < ApplicationController
    before_action :find_trip
    before_action :authenticate_user!, only: [:create]
    before_action :authorize!, only: [:create]
    before_action :api_authorize_readonly!, only: [:index]

    def index
      render json: {
        days: @trip.days.includes(:transfers, :hotel, :places)
          .as_json(user_currency: current_user.try(:currency),
                   include: [:transfers, :hotel, :places])
      }
    end

    def create
      days_params[:days].each do |day_params|
        day = @trip.days.where(id: day_params.delete(:id)).first
        Updaters::Transfers.new(day, day_params.delete(:transfers)).process
        Updaters::DayPlaces.new(day, day_params.delete(:places)).process
        Updaters::Hotel.new(day, day_params.delete(:hotel)).process
      end
      Calculators::Budget.new(@trip).invalidate_cache!
      render json: { status: 0 }
    end

    private

    def days_params
      params.permit(
        days: [
          :id,
          {
            transfers: [
              :id, :type, :code, :company, :station_from, :station_to,
              :start_time, :end_time, :comment, :amount_cents, :amount_currency,
              :city_to_id, :city_from_id,
              { links: [:id, :url, :description] }
            ]
          },
          {
            hotel: [
              :id, :name, :comment, :amount_cents, :amount_currency,
              { links: [:id, :url, :description] }
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
      head(404) && return if @trip.blank?
    end

    def authorize!
      head(403) && return unless @trip.include_user(current_user)
    end
  end
end
