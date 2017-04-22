# frozen_string_literal: true

module Api
  class ManualCitiesController < Api::BaseController
    before_action :authenticate_user!
    before_action :find_user
    before_action :authorize

    def index
      render json: {
        manual_cities: Views::CityView.index_json(
          @user.manual_cities.with_translations
        )
      }
    end

    def create
      @user.manual_city_ids = params[:manual_cities_ids]
      @user.save

      render json: {
        sucess: true
      }
    end

    private

    def find_user
      @user = User.find(params[:user_id])
    end

    def authorize
      head(403) && return unless @user == current_user
    end
  end
end
