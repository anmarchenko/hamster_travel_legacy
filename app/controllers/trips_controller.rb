class TripsController < ApplicationController

  include Concerns::ImageUploading

  TRANSFERS_GRID = [0.1, 0.1, 0.45, 0.35]

  before_action :authenticate_user!, only: [:edit, :update, :new, :create, :destroy, :upload_photo]
  before_action :find_trip, only: [:show, :edit, :update, :destroy, :upload_photo]
  before_action :find_original_trip, only: [:new, :create]
  before_action :authorize, only: [:edit, :update, :upload_photo]
  before_action :authorize_destroy, only: [:destroy]
  before_action :authorize_show, only: [:show]

  def index
    # TODO move to service
    if params[:my] && !current_user.blank?
      @trips = current_user.trips.where.not(status_code: Travels::Trip::StatusCodes::DRAFT)
      @trips = @trips.order(start_date: :desc)
    elsif params[:my_draft] && !current_user.blank?
      @trips = current_user.trips.where(status_code: Travels::Trip::StatusCodes::DRAFT)
      @trips = @trips.order(dates_unknown: :asc, start_date: :desc, name: :asc)
    else
      @trips = Travels::Trip.where(private: false).where.not(status_code: Travels::Trip::StatusCodes::DRAFT)
      @trips = @trips.order(status_code: :desc, start_date: :desc)
    end
    @trips = @trips.includes(:author_user)
    @trips = @trips.page(params[:page] || 1)
  end

  def new
    @trip = Creators::Trip.new(@original_trip, params).new_trip
  end

  def create
    @trip = Creators::Trip.new(@original_trip, params_trip, current_user).create_trip
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
    Updaters::Trip.new(@trip).update(params_trip)
    redirect_to trip_path(@trip), notice: t('common.update_successful') and return if @trip.errors.blank?
    render 'edit'
  end

  def show
    @user_can_edit = (user_signed_in? and @trip.include_user(current_user))

    respond_to do |format|
      format.html
      format.docx do
        @transfers_grid = TRANSFERS_GRID

        headers["Content-Disposition"] = "attachment; filename=\"#{@trip.name_for_file}.docx\""
      end
    end
  end

  def destroy
    @trip.archived = true
    @trip.save validate: false
    Travels::TripInvite.where(trip_id: @trip.id).destroy_all
    redirect_to trips_path(my: true)
  end

  private

  def params_trip
    params.require(:travels_trip).permit(:name, :short_description, :start_date, :end_date, :image, :status_code,
      :private, :currency, :planned_days_count, :dates_unknown)
  end

  def find_trip
    @trip = Travels::Trip.includes(:users, :author_user, {days: [{hotel: :links}, :activities, :transfers, :places, :expenses]}).where(id: params[:id]).first
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

end