# frozen_string_literal: true
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @edit = (@user == current_user)
  rescue ActiveRecord::RecordNotFound
    not_found
  end
end
