# frozen_string_literal: true

module Api
  class BudgetsController < ApplicationController
    respond_to :json

    before_action :find_trip
    before_action :api_authorize_readonly!, only: [:show]

    before_action :authenticate_user!, only: [:update]
    before_action :authorize, only: [:update]

    def show
      render json: ::Views::BudgetView.show_json(
        Budgets.calculate_info(@trip, current_user&.currency)
      )
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
