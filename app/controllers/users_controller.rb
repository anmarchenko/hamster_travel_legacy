class UsersController < ApplicationController
  include Concerns::ImageUploading

  before_filter :authenticate_user!, only: [:edit, :update, :upload_photo]
  before_filter :find_user
  before_filter :authorize, only: [:edit, :update, :upload_photo]

  def show
    @trips = @user.trips.page(params[:page] || 1)
  end

  def edit
  end

  def update
    redirect_to edit_user_path(@user, {locale: @user.locale}), notice: t('users.update_successful', locale: @user.locale) and return if @user.update_attributes user_params
    render 'edit'
  end

  def upload_photo
    save_image @user, user_params[:image], '100x100'

    respond_to do |format|
      format.js
    end
  end

  def find_user
    @user = User.where(id: params[:id]).first
    head 404 and return if @user.blank?
  end

  def authorize
    no_access and return if @user.id != current_user.id
  end

  def user_params
    params.require(:user).permit(:locale, :home_town_text, :home_town_id, :image, :currency)
  end

end