class Api::UsersController < ApplicationController
  def index
    term = params[:term] || ''
    render json: [] and return if term.blank? || term.length < 2

    query = User.find_by_term(term).page(1)
    query = query.where.not(:id => current_user.id) if current_user.present?
    res = query.collect { |user| {name: user.full_name, text: user.full_name, code: user.id.to_s,
                                  photo_url: user.image_url, color: user.background_color, initials: user.initials} }

    render json: res
  end
end