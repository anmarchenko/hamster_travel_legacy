class Websockets::UserEditsController < WebsocketRails::BaseController
  @@c = 0
  def client_connected
    @@c += 1
    send_message :response, 'connected' + @@c.to_s
  end

  def hello
    p message
    send_message :response, 'hello'
  end

end