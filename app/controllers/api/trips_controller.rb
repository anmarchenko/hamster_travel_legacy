module Api
  class TripsController < ApplicationController
    before_action :authenticate_user!, only: [:upload_image, :delete_image, :destroy]
    before_action :find_trip, only: [:upload_image, :delete_image, :destroy]
    before_action :authorize, only: [:upload_image, :delete_image]
    before_action :authorize_destroy, only: [:destroy]

    def index
      term = params[:term] || ''
      render json: Finders::Trips.search(term, current_user).includes(:cities).map(&:short_json)
    end

    def upload_image
      @trip.image = params[:file]
      @trip.image.name = 'photo.png'
      @trip.save
      render json: {
        status: 0,
        image_url: @trip.image_url_or_default
      }
    end

    def delete_image
      @trip.image = nil
      @trip.save
      render json: {
        status: 0,
        image_url: @trip.image_url_or_default
      }
    end

    def destroy
      @trip.archived = true
      @trip.save validate: false
      Travels::TripInvite.where(trip_id: @trip.id).destroy_all
      render json: { success: true }
    end

    private

    def find_trip
      @trip = Travels::Trip.includes(:users, :author_user).where(id: params[:id]).first
      not_found and return if @trip.blank?
    end

    def authorize
      render json: { error: 'forbidden' }, status: 403 and return unless @trip.include_user(current_user)
    end

    def authorize_destroy
      render json: { error: 'forbidden' }, status: 403 and return unless @trip.author_user_id == current_user.id
    end
  end
end
