class UsersController < ApplicationController

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
    @user.image = user_params[:image]
    if @user.image && @user.valid?
      # crop before save
      job = @user.image.convert("-crop #{params[:w]}x#{params[:h]}+#{params[:x]}+#{params[:y]}") rescue nil
      if job
        job.apply
        @user.update_attributes(image: job.content)
      end
    else
      @user.save
    end

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
    params.require(:user).permit(:locale, :home_town_text, :home_town_code, :image)
  end

end