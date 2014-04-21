class TripsController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update, :new, :create]
  before_filter :find_trip, only: [:show, :edit, :update, :destroy]
  before_filter :authorize, only: [:edit, :update, :destroy]

  def index
    if params[:my] && !current_user.blank?
      @trips = current_user.trips
    else
      @trips = Travels::Trip.all
    end
    @trips = @trips.page(params[:page] || 1)
  end

  def new
    @trip = Travels::Trip.new
  end

  def create
    @trip = Travels::Trip.new(params_trip)
    @trip.author_user_id = current_user.id
    @trip.users = [current_user]
    @trip.save

    redirect_to trip_path(@trip) and return if @trip.errors.blank?
    render 'new'
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end

  private

  def params_trip
    params.require(:travels_trip).permit(:name, :short_description, :start_date, :end_date)
  end

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    head 404 and return if @trip.blank?
  end

  def authorize
    no_access and return if !@trip.include_user(current_user)
  end

end