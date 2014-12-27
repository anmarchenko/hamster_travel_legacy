class Websockets::UserEditsController < WebsocketRails::BaseController

  def client_connected
    send_message :response, "connected user"
  end

  def inc
    send_message :response, "inc #{message[:user_id]} trip #{message[:trip_id]} channel #{message[:channel]}"
  end

  def dec
    send_message :response, "dec #{message[:user_id]} trip #{message[:trip_id]} channel #{message[:channel]}"
  end

end