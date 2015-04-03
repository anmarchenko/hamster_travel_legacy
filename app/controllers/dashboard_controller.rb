class DashboardController < ApplicationController

  def index
    @trips = Travels::Trip.where(private: false).order(created_at: :desc).page(1).per(3)
  end

end
