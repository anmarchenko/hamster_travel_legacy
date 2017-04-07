# frozen_string_literal: true

module Api
  class BudgetsController < ApplicationController
    respond_to :json

    before_action :find_trip
    before_action :authenticate_user!, only: [:update]
    before_action :authorize, only: [:update]
    before_action :api_authorize_readonly!, only: [:show]

    def show
      render json: {
        budget: {
          sum: @trip.budget_sum(current_user.try(:currency)),
          transfers_hotel_budget: @trip.transfers_hotel_budget(
            current_user.try(:currency)
          ),
          activities_other_budget: @trip.activities_other_budget(
            current_user.try(:currency)
          ),
          catering_budget: @trip.catering_budget(current_user.try(:currency)),
          budget_for: @trip.budget_for
        }
      }
    end

    def update
      render json: {
        res: ::Trips.update_budget_for(@trip, params[:budget_for])
      }
    end

    private

    def authorize
      head(403) && return unless @trip.include_user(current_user)
    end

    def find_trip
      @trip = Travels::Trip.where(id: params[:id]).first
      head(404) && return if @trip.blank?
    end
  end
end
