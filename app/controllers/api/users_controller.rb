module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:upload_image, :delete_image, :update]
    before_action :find_user, only: [:show, :update, :upload_image, :delete_image,
                                     :planned_trips, :finished_trips, :visited]
    before_action :authorize, only: [:upload_image, :delete_image, :update]

    def index
      term = params[:term] || ''
      render json: [] and return if term.blank? || term.length < 2

      query = User.find_by_term(term).page(1)
      query = query.where.not(id: current_user.id) if current_user.present?
      res = query.collect do |user|
        {
          name: user.full_name, text: user.full_name, code: user.id.to_s,
          photo_url: user.image_url, color: user.background_color, initials: user.initials
        }
      end

      render json: res
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
      render json: { trips: Finders::Trips.for_user_planned(@user, params[:page], current_user)
                                          .includes(:cities)
                                          .map { |trip| trip.short_json(32) } }
    end

    def finished_trips
      render json: { trips: Finders::Trips.for_user_finished(@user, params[:page], current_user)
                                          .includes(:cities)
                                          .map { |trip| trip.short_json(32) } }
    end

    def visited
      render json: {
        countries: @user.visited_countries.map(&:visited_country_json).sort_by { |json| json[:name] },
        cities: @user.visited_cities.map(&:json_hash)
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
      params.require(:user).permit(:locale, :home_town_id, :currency, :first_name, :last_name)
    end
  end
end
