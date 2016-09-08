class HomePageController < ApplicationController
  def index
    @transparent_navbar = true
    @hide_footer = true
  end
end
