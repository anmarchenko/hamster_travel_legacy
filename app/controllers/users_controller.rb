class UsersController < ApplicationController

  before_filter :authenticate_user!, only: [:edit, :update]
  before_filter :find_user
  before_filter :authorize, only: [:edit, :update]

  def show
  end

  def edit
  end

  def update
  end

  def find_user
    @user = User.where(id: params[:id]).first
    head 404 and return if @user.blank?
  end

  def authorize
    no_access and return if @user.id != current_user.id
  end

end