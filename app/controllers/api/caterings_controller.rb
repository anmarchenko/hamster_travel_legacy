module Api
  class CateringsController < ApplicationController

    before_action :find_trip
    before_action :authenticate_user!, only: [:update]
    before_action :authorize, only: [:update]
    before_action :api_authorize_readonly!, only: [:show]

    respond_to :json

    def show
      render json: {
        caterings: @trip.caterings_data
      }
    end

    def update
      ::Updaters::Caterings.new(@trip, params_caterings[:caterings]).process
      render json: {
          res: true
      }
    end

    private

    def params_caterings
      params.require(:trip).permit(caterings: [:id, :name, :description, :days_count, :persons_count,
                                        :amount_cents, :amount_currency])
    end

    def find_trip
      @trip = Travels::Trip.where(id: params[:id]).first
      head 404 and return if @trip.blank?
    end

    def authorize
      head 403 and return if !@trip.include_user(current_user)
    end

  end
end