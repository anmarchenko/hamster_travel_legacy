# frozen_string_literal: true

class TripsController < ApplicationController
  TRANSFERS_GRID = [0.1, 0.1, 0.45, 0.35].freeze

  before_action :authenticate_user!, only: %i(edit update new
                                              create my drafts)
  before_action :find_trip, only: %i(show edit update)
  before_action :find_original_trip, only: %i(new create)
  before_action :authorize, only: %i(edit update)
  before_action :authorize_destroy, only: [:destroy]
  before_action :authorize_show, only: [:show]

  def index
    @trips = Finders::Trips.all(params[:page]).includes(:author_user, :cities)
  end

  def my
    @trips = Finders::Trips.for_user(current_user, params[:page]).includes(
      :author_user, :cities
    )
  end

  def drafts
    @trips = Finders::Trips.drafts(current_user, params[:page]).includes(
      :author_user, :cities
    )
  end

  def new
    @trip = Creators::Trip.new(@original_trip).new_trip
  end

  def create
    @trip = Creators::Trip.new(@original_trip)
                          .create_trip(params_trip, current_user)
    redirect_to(trip_path(@trip)) && return if @trip.errors.blank?
    render 'new'
  end

  def edit; end

  def update
    Updaters::Trip.new(@trip).update(params_trip)
    if @trip.errors.blank?
      redirect_to(trip_path(@trip), notice: t('common.update_successful'))
      return
    end
    render 'edit'
  end

  def show
    @user_can_edit = (user_signed_in? && @trip.include_user(current_user))
    @multiday = @trip.days.count > 1

    respond_to do |format|
      format.html
      format.docx do
        @transfers_grid = TRANSFERS_GRID
        docx_name = "#{@trip.name_for_file}.docx"
        headers['Content-Disposition'] = "attachment; filename=\"#{docx_name}\""
      end
    end
  end

  private

  def params_trip
    params.require(:travels_trip).permit(
      :name, :short_description, :start_date,
      :end_date, :image, :status_code,
      :private, :currency, :planned_days_count, :dates_unknown
    )
  end

  def find_trip
    @trip = Travels::Trip.includes(:users, :author_user, days:
      [
        { hotel: :links }, :activities, :transfers, :places, :expenses
      ]).where(id: params[:id]).first
    not_found && return if @trip.blank?
  end

  def find_original_trip
    return if params[:copy_from].blank?
    @original_trip = Travels::Trip.where(id: params[:copy_from]).first
    @original_trip = nil unless @original_trip&.can_be_seen_by?(current_user)
  end

  def authorize
    no_access && return unless @trip.include_user(current_user)
  end

  def authorize_show
    return unless @trip.private
    no_access && return unless user_signed_in?
    no_access && return unless @trip.can_be_seen_by?(current_user)
  end
end
