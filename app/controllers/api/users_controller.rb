class Api::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:upload_image, :delete_image]
  before_action :find_user, only: [:show, :upload_image, :delete_image, :planned_trips, :finished_trips]
  before_action :authorize, only: [:upload_image, :delete_image]

  def index
    term = params[:term] || ''
    render json: [] and return if term.blank? || term.length < 2

    query = User.find_by_term(term).page(1)
    query = query.where.not(:id => current_user.id) if current_user.present?
    res = query.collect { |user| {name: user.full_name, text: user.full_name, code: user.id.to_s,
                                  photo_url: user.image_url, color: user.background_color, initials: user.initials} }

    render json: res
  end

  def show
    render json: { user: @user }
  end

  def upload_image
    @user.image = params[:file]
    @user.image.name = 'photo.png'
    @user.save
    render json: {
      status: 0,
      image_url: @user.image_url
    }
  end

  def delete_image
    @user.image = nil
    @user.save
    render json: {
      status: 0,
      image_url: @user.image_url
    }
  end

  def planned_trips
    render json: { trips: Finders::Trips.for_user_planned(@user, params[:page], current_user).map(&:short_json) }
  end

  def finished_trips
    render json: { trips: Finders::Trips.for_user_finished(@user, params[:page], current_user).map(&:short_json) }
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def authorize
    no_access and return unless @user == current_user
  end
end
