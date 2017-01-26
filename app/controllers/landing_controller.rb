class LandingController < ApplicationController
  def index
    @transparent_navbar = true
    @hide_footer = true
  end

  def welcome
    redirect_to "/#{I18n.locale}/landing"
  end
end
