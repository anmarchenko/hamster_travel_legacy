# frozen_string_literal: true
module Api
  class TripsController < ApplicationController
    before_action :authenticate_user!, only: [
      :upload_image, :delete_image, :destroy
    ]
    before_action :find_trip, only: [:upload_image, :delete_image, :destroy]
    before_action :authorize, only: [:upload_image, :delete_image]
    before_action :authorize_destroy, only: [:destroy]

    def index
      term = params[:term] || ''
      trips = Finders::Trips.search(term, current_user)
      render json: trips.includes(:cities).map(&:short_json)
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
      @trip = Travels::Trip.includes(:users, :author_user)
                           .where(id: params[:id]).first
      not_found && return if @trip.blank?
    end

    def authorize
      return if @trip.include_user(current_user)
      render(json: { error: 'forbidden' }, status: 403)
    end

    def authorize_destroy
      return if @trip.author_user_id == current_user.id
      render(json: { error: 'forbidden' }, status: 403)
    end
  end
end
