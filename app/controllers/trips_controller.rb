class TripsController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update, :new, :create, :destroy]
  before_filter :find_trip, only: [:show, :edit, :update, :destroy]
  before_filter :authorize, only: [:edit, :update]
  before_filter :authorize_destroy, only: [:destroy]

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
    @trip.update_attributes(params_trip)
    redirect_to trip_path(@trip), notice: t('common.update_successful') and return if @trip.errors.blank?
    render 'edit'
  end

  def show
    respond_to do |format|
      format.html
      format.docx do
        weights = {'day' => 0.1, 'show_place' => 0.1, 'show_transfers' => 0.15, 'show_hotel' => 0.15,
                    'show_activities' => 0.35, 'show_comments' => 0.15}

        params[:cols] ||= []
        count = params[:cols].select{|col| col != 'show_place'}.count
        cols = ['day'] + params[:cols]
        @grid = []
        cols.each {|col| @grid << weights[col]}

        weights.keys.each do |key|
          unless cols.include?(key)
            add = weights[key] / count
            @grid.each_index {|index| @grid[index] += add unless @grid[index] == 0.1 }
          end
        end

        headers["Content-Disposition"] = "attachment; filename=\"#{@trip.name_for_file}.docx\""
      end
    end
  end

  def destroy
    @trip.set(archived: true)
    redirect_to trips_path(my: true)
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

  def authorize_destroy
    no_access and return if !(@trip.author_user_id == current_user.id)
  end

end