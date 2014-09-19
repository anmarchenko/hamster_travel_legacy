class DashboardController < ApplicationController

  def index
    @trips = Travels::Trip.order_by(created_at: -1).page(1).per(3)
  end

end
