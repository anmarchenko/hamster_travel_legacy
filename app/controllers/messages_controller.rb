class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @invites = current_user.incoming_invites.includes(:inviting_user, :trip)
  end
end