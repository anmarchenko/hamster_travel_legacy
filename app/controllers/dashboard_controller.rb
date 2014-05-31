class DashboardController < ApplicationController

  def index
    @trips = Travels::Trip.limit(3).page(1)
  end

end
