# frozen_string_literal: true

class Presence
  def initialize
    @client = Redis.new(host: Settings.redis.host, port: 6379, driver: :hiredis)
  end

  def present_users(trip_id, current_user_id)
    add_current_user!(trip_id, current_user_id)
    remove_not_present!(trip_id)

    present_users_names(trip_id, current_user_id)
  end

  private

  def present_users_names(trip_id, current_user_id)
    @client.zrange(trip_id, 0, -1).map do |user_id|
      next if user_id == current_user_id.to_s
      User.find(user_id).full_name
    end.compact
  end

  def add_current_user!(trip_id, current_user_id)
    @client.zadd(trip_id, Time.now.to_i, current_user_id)
  end

  def remove_not_present!(trip_id)
    @client.zremrangebyscore(trip_id, '-inf', (Time.now - 10.seconds).to_i)
  end
end
