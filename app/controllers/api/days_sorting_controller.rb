# frozen_string_literal: true
class Api::DaysSortingController < ApplicationController
  before_action :find_trip
  before_action :authenticate_user!
  before_action :authorize

  respond_to :json

  def index
    respond_with @trip.days.map(&:short_hash)
  end

  def create
    days = @trip.days.to_a
    days_sorted = params[:day_ids].map { |day_id| days.find { |day| day.id.to_s == day_id.to_s } }
    @trip.ensure_days_order days_sorted
    render json: { result: :ok }
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:trip_id]).first
    head(404) && return if @trip.blank?
  end

  def authorize
    head(403) && return unless @trip.include_user(current_user)
  end
end
