class Api::UsersController < ApplicationController
  respond_to :json

  def index
    term = params[:term] || ''
    respond_with [] and return if term.blank? || term.length < 2
    # cache here by term
    res = Rails.cache.fetch("users_by_#{term}_2016_02_14_2", :expires_in => 1.hour.to_i) do
      query = User.find_by_term(term).page(1)
      query = query.where.not(:id => current_user.id) if current_user.present?
      query.collect { |user| {name: user.full_name, text: user.full_name, code: user.id.to_s,
                              photo_url: user.image_url, color: user.background_color, initials: user.initials} }
    end
    respond_with res
  end
end