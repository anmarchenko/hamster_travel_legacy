class Api::ParticipantsController < ApplicationController

  before_filter :find_trip

  def index
    render json: {
               users: collect_users(@trip.users),
               invited_users: collect_users(@trip.invited_users)
           }
  end

  private

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    header 404 and return if @trip.blank?
  end

  def collect_users users
    users.collect do |user|
      {id: user.id.to_s, photo_url: user.image_url_or_default, name: user.full_name}
    end
  end

end