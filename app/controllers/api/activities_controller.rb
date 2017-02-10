# frozen_string_literal: true
class Api::ActivitiesController < ApplicationController
  before_action :find_trip
  before_action :find_day
  before_action :authenticate_user!, only: [:create]
  before_action :authorize, only: [:create]
  before_action :api_authorize_readonly!, only: [:index]

  def index
    render json: @day.as_json(user_currency: current_user.try(:currency), include: [:expenses, :activities, :links, :places])
  end

  def create
    prms = day_params
    ::Updaters::Activities.new(@day, prms.delete(:activities)).process
    ::Updaters::DayExpenses.new(@day, prms.delete(:expenses)).process
    ::Updaters::DayLinks.new(@day, prms.delete(:links)).process
    ::Updaters::DayPlaces.new(@day, prms.delete(:places)).process
    ::Updaters::Day.new(@day, prms).process
    Calculators::Budget.new(@trip).invalidate_cache!
    render json: { status: 0 }
  end

  private

  def day_params
    params.require(:day).permit(
      :comment,
      activities: [
        :id, :name, :comment, :link_url, :amount_cents, :amount_currency, :rating, :address, :working_hours
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
