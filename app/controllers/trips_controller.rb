class TripsController < ApplicationController

  include Concerns::ImageUploading

  WEIGHTS = {'day' => 0.1, 'show_place' => 0.1, 'show_transfers' => 0.15, 'show_hotel' => 0.15,
             'show_activities' => 0.35, 'show_comments' => 0.15}

  before_filter :authenticate_user!, only: [:edit, :update, :new, :create, :destroy, :upload_photo]
  before_filter :find_trip, only: [:show, :edit, :update, :destroy, :upload_photo]
  before_filter :find_original_trip, only: [:new, :create]
  before_filter :authorize, only: [:edit, :update, :upload_photo]
  before_filter :authorize_destroy, only: [:destroy]
  before_filter :authorize_show, only: [:show]

  def index
    if params[:my] && !current_user.blank?
      @trips = current_user.trips
    else
      @trips = Travels::Trip.where(private: false)
    end
    @trips = @trips.order_by(status_code: -1, start_date: -1)
    @trips = @trips.page(params[:page] || 1)
  end

  def new
    @trip = Travels::Updaters::TripUpdater.new(@original_trip, params).new_trip
  end

  def create
    @trip = Travels::Updaters::TripUpdater.new(@original_trip, params_trip, current_user).create_trip
    redirect_to trip_path(@trip) and return if @trip.errors.blank?
    render 'new'
  end

  def upload_photo
    save_image @trip, params_trip[:image], '300x300'
    respond_to do |format|
      format.js
    end
  end

  def edit
  end

  def update
    @trip.update_attributes(params_trip)
    redirect_to trip_path(@trip), notice: t('common.update_successful') and return if @trip.errors.blank?
    render 'edit'
  end

  def show
    @user_can_edit = (user_signed_in? and @trip.include_user(current_user))

    respond_to do |format|
      format.html
      format.docx do
        @grid = docx_grid

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
    params.require(:travels_trip).permit(:name, :short_description, :start_date, :end_date, :image, :status_code,
      :private)
  end

  def find_trip
    @trip = Travels::Trip.where(id: params[:id]).first
    head 404 and return if @trip.blank?
  end

  def find_original_trip
    unless params[:copy_from].blank?
      @original_trip = Travels::Trip.where(id: params[:copy_from]).first
      @original_trip = nil if !@original_trip.blank? && !@original_trip.can_be_seen_by?(current_user)
    end
  end

  def authorize
    no_access and return unless @trip.include_user(current_user)
  end

  def authorize_destroy
    no_access and return unless (@trip.author_user_id == current_user.id)
  end

  def authorize_show
    return unless @trip.private
    no_access and return unless user_signed_in?
    no_access and return unless @trip.can_be_seen_by?(current_user)
  end

  def docx_grid
    params[:cols] ||= []
    count = params[:cols].select{|col| col != 'show_place'}.count
    cols = ['day'] + params[:cols]
    grid = []
    cols.each {|col| grid << WEIGHTS[col]}

    WEIGHTS.keys.each do |key|
      unless cols.include?(key)
        add = WEIGHTS[key] / count
        grid.each_index {|index| grid[index] += add unless grid[index] == 0.1 }
      end
    end

    grid
  end

end