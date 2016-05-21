class Api::BudgetsController < ApplicationController
  respond_to :json

  before_action :find_trip
  before_action :authenticate_user!, only: [:update]
  before_action :authorize, only: [:update]

  def show
    render json: {
        budget: {
            sum: @trip.budget_sum(current_user.try(:currency)),
            transfers_hotel_budget: @trip.transfers_hotel_budget(current_user.try(:currency)),
            activities_other_budget: @trip.activities_other_budget(current_user.try(:currency)),
            catering_budget: @trip.catering_budget(current_user.try(:currency)),
            budget_for: @trip.budget_for
        }
    }
  end

  def update
    res = ::Updaters::Trip.new(@trip).update_budget_for(params[:budget_for])
    render json: {
        res: res
    }
  end

  private

  def authorize
    head 403 and return if !@trip.include_user(current_user)
  end

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    head 404 and return if @trip.blank?
  end
end