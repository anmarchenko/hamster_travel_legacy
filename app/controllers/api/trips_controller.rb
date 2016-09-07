module Api
  class TripsController < ApplicationController
    before_action :authenticate_user!, only: [:upload_image]
    before_action :find_trip, only: [:upload_image]
    before_action :authorize, only: [:upload_image]

    def index
      term = params[:term] || ''
      render json: [] and return if term.blank?
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

    private

    def authorize
      no_access and return unless @trip.include_user(current_user)
    end

    def find_trip
      @trip = Travels::Trip.includes(:users, :author_user).where(id: params[:id]).first
      not_found and return if @trip.blank?
    end
  end
end
