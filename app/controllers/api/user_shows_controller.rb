module Api

  class UserShowsController < ApplicationController

    before_action :find_trip
    before_action :authenticate_user!
    before_action :authorize

    respond_to :json

    def show
      $redis.zadd(params[:id], Time.now.to_i, current_user.id)
      $redis.zremrangebyscore(params[:id], '-inf', (Time.now - 10.seconds).to_i)
      res = $redis.zrange(params[:id], 0, -1).map do |user_id|
        User.find(user_id).try(:full_name) unless user_id == current_user.id.to_s
      end.compact
      respond_with res
    end

    def find_trip
      @trip = Travels::Trip.where(id: params[:id]).first
      head 404 and return if @trip.blank?
    end

    def authorize
      head 403 and return if !@trip.include_user(current_user)
    end

  end

end