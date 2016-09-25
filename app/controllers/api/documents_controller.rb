module Api
  class DocumentsController  < ApplicationController
    before_action :authenticate_user!
    before_action :find_trip
    before_action :authorize

    def index
      render json: { documents: @trip.documents }
    end

    def create
      (params[:files] || {}).values.each do |file|
        document = Travels::Document.new(name: file.original_filename, mime_type: file.content_type, trip: @trip)
        document.store(file)
        document.save
      end
      render json: { success: true }
    end

    def update
    end

    def show
    end

    def destroy
    end

    private

    def find_trip
      @trip = Travels::Trip.includes(:users).where(id: params[:trip_id]).first
      not_found and return if @trip.blank?
    end

    def authorize
      no_access and return unless @trip.include_user(current_user)
    end
  end
end
