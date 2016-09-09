class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :upload_photo]
  before_action :find_user
  before_action :authorize, only: [:edit, :update, :upload_photo]

  def show
    @trips = @user.trips.page(params[:page] || 1)
    @transparent_navbar = true
  end

  def edit
  end

  def update
    redirect_to edit_user_path(@user, {locale: @user.locale}), notice: t('users.update_successful', locale: @user.locale) and return if @user.update_attributes user_params
    render 'edit'
  end

  def find_user
    @user = User.where(id: params[:id]).first
    not_found and return if @user.blank?
  end

  def authorize
    no_access and return if @user.id != current_user.id
  end

  def user_params
    params.require(:user).permit(:locale, :home_town_id, :image, :currency)
  end

end