class UsersController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]
  before_filter :find_user
  before_filter :authorize, only: [:edit, :update]

  def show
  end

  def edit
  end

  def update
    p params
    if @user.update_attributes user_params
      flash[:notice] = t('users.update_successful', locale: @user.locale)
      redirect_to edit_user_path @user, locale: @user.locale
    else
      render 'edit'
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
    params.require(:user).permit(:locale, :home_town_text, :home_town_code)
  end

end