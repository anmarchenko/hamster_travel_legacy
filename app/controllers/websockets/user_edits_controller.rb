class Websockets::UserEditsController < WebsocketRails::BaseController

  def client_connected
    send_message :response, 'connected'
  end

  def hello
    send_message :response, 'hello'
  end

end