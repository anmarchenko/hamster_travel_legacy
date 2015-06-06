class Api::BudgetsController < ApplicationController
  respond_to :json

  before_filter :find_trip

  def show
    render json: {budget: @trip.budget_sum}
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    head 404 and return if @trip.blank?
  end
end