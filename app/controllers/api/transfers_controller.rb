# frozen_string_literal: true

module Api
  class TransfersController < ApplicationController
    before_action :find_trip
    before_action :find_day
    before_action :authenticate_user!, only: [:create]
    before_action :authorize, only: [:create]
    before_action :api_authorize_readonly!, only: %i[
      index previous_place previous_hotel
    ]

    def index
      render json: @day.as_json(
        user_currency: current_user.try(:currency),
        include: %i[transfers hotel places]
      )
    end

    def create
      prms = day_params
      Updaters::Transfers.new(@day, prms.delete(:transfers)).process
      Updaters::DayPlaces.new(@day, prms.delete(:places)).process
      Updaters::Hotel.new(@day, prms.delete(:hotel)).process
      Calculators::Budget.new(@trip).invalidate_cache!
      render json: { status: 0 }
    end

    def previous_place
      previous_day = @trip.days.where(index: @day.index - 1).first
      render json: {
        place: previous_day.try(:places).try(:last)
      }
    end

    def previous_hotel
      previous_day = @trip.days.where(index: @day.index - 1).first
      render json: {
        hotel: previous_day.try(:hotel)
      }
    end

    private

    def day_params
      params.require(:day).permit(
        transfers: [
          :id, :type, :code, :company, :station_from, :station_to, :start_time,
          :end_time, :comment, :amount_cents, :amount_currency, :city_to_id,
          :city_from_id, { links: %i[id url description] }
        ],
        hotel: [
          :id, :name, :comment, :amount_cents, :amount_currency,
          { links: %i[id url description] }
        ],
        places: %i[
          id city_id
        ]
      )
    end

    def authorize
      head(403) && return unless @trip.include_user(current_user)
    end

    def find_trip
      @trip = Travels::Trip.where(id: params[:trip_id]).first
      head(404) && return if @trip.blank?
    end

    def find_day
      @day = @trip.days.where(id: params[:day_id]).first
      head(404) && return if @day.blank?
    end
  end
end
