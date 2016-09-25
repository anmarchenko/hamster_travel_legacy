require 'rack/mime'

module Api
  class DocumentsController  < ApplicationController
    EXTENSIONS = Rack::Mime::MIME_TYPES.invert

    before_action :authenticate_user!
    before_action :find_trip
    before_action :find_document, only: [:update, :show, :destroy]
    before_action :authorize

    def index
      render json: { documents: @trip.documents }
    end

    def create
      (params[:files] || {}).values.each do |file|
        name = File.basename(file.original_filename, File.extname(file.original_filename))
        document = Travels::Document.new(name: name, mime_type: file.content_type, trip: @trip)
        document.store(file)
        document.save
      end
      render json: { success: true }
    end

    def update
      res = @document.update_attributes(name: params[:name])
      render json: { success: res }
    end

    def show
      file_stream = open(@document.file.remote_url)
      send_data file_stream.read, filename: "#{@document.name}#{EXTENSIONS[@document.mime_type]}",
                                  type: @document.mime_type,
                                  disposition: 'inline'
    end

    def destroy
      @document.destroy
      render json: { success: @document.destroyed? }
    end

    private

    def find_trip
      @trip = Travels::Trip.includes(:users).where(id: params[:trip_id]).first
      not_found and return if @trip.blank?
    end

    def authorize
      no_access and return unless @trip.include_user(current_user)
    end

    def find_document
      @document = Travels::Document.find(params[:id])
    end
  end
end
