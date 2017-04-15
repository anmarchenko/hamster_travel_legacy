# frozen_string_literal: true

require 'rack/mime'

module Api
  class DocumentsController < Api::BaseController
    before_action :authenticate_user!
    before_action :find_trip
    before_action :find_document, only: %i[update show destroy]
    before_action :authorize

    def index
      render json: { documents: @trip.documents }
    end

    def create
      Documents.create(@trip, params[:files])
      render json: { success: true }
    end

    def update
      res = @document.update_attributes(name: params[:name])
      render json: { success: res }
    end

    def show
      file_stream = open(@document.file.remote_url)
      send_data(
        file_stream.read,
        filename: "#{@document.name}#{@document.extension}",
        type: @document.mime_type,
        disposition: 'inline'
      )
    end

    def destroy
      @document.destroy
      render json: { success: @document.destroyed? }
    end

    private

    def find_trip
      @trip = ::Trips.by_id(params[:trip_id])
    end

    def authorize
      no_access && return unless @trip.include_user(current_user)
    end

    def find_document
      @document = @trip.documents.where(id: params[:id]).first
      not_found && return if @document.blank?
    end
  end
end
