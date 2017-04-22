# frozen_string_literal: true

module Api
  class UsersController < Api::BaseController
    before_action :authenticate_user!, only: %i[
      upload_image delete_image update
    ]
    before_action :find_user, only: %i[
      show update upload_image delete_image
      planned_trips finished_trips visited
    ]
    before_action :authorize, only: %i[upload_image delete_image update]

    def index
      render json: Views::UserView.index_json(
        Users.search(params[:term], current_user)
      )
    end

    def show
      render json: { user: @user }
    end

    def update
      success = @user.update_attributes(user_params)
      if success
        render json: { error: false }
      else
        render json: { error: true, errors: @user.errors }, status: 422
      end
    end

    def upload_image
      @user.image = params[:file]
      @user.image.name = 'photo.png'
      @user.save
      render json: {
        status: 0,
        image_url: @user.image_url
      }
    end

    def delete_image
      @user.image = nil
      @user.save
      render json: {
        status: 0,
        image_url: @user.image_url
      }
    end

    def planned_trips
      render json: {
        trips: Views::TripView.index_list_json(
          UserProfile.list_next_planned_trips(@user, current_user),
          flag_size: 32
        )
      }
    end

    def finished_trips
      render json: {
        trips: Views::TripView.index_list_json(
          UserProfile.list_last_finished_trips(@user, current_user),
          flag_size: 32
        )
      }
    end

    def visited
      # TODO: refactor this
      countries = @user.visited_countries
                       .map(&:visited_country_json)
                       .sort_by { |json| json[:name] }
      render json: {
        countries: countries,
        cities: Views::CityView.index_json(@user.visited_cities)
      }
    end

    private

    def find_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: true }, status: 404
    end

    def authorize
      return if @user == current_user
      render json: { error: true }, status: 403
    end

    def user_params
      params.require(:user).permit(
        :locale, :home_town_id, :currency, :first_name, :last_name
      )
    end
  end
end
