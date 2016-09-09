class Api::UsersController < ApplicationController
  before_action :find_user, only: [:show]

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

  private

  def find_user
    @user = User.find(params[:id])
  end
end