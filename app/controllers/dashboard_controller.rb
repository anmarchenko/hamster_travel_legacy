class DashboardController < ApplicationController

  def index
    @trips = Travels::Trip.page(1).per(3)
  end

end
