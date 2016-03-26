class Api::BudgetsController < ApplicationController
  respond_to :json

  before_action :find_trip

  def show
    render json: {
        budget: {
            sum: @trip.budget_sum(current_user.try(:currency)),
            transfers_hotel_budget: @trip.transfers_hotel_budget(current_user.try(:currency)),
            activities_other_budget: @trip.activities_other_budget(current_user.try(:currency)),
            catering_budget: @trip.catering_budget(current_user.try(:currency))
        }
    }
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    head 404 and return if @trip.blank?
  end
end