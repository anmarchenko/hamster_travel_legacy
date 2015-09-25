class Api::ParticipantsController < ApplicationController

  before_filter :find_trip

  def index
    render json: @trip.users.collect {|user| {id: user.id.to_s, photo_url: user.image_url_or_default,
                                              name: user.full_name} }
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    header 404 and return if @trip.blank?
  end

end