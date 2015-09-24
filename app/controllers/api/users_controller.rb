class Api::UsersController < ApplicationController
  respond_to :json

  def index
    term = params[:term] || ''
    respond_with [] and return if term.blank? || term.length < 2
    # cache here by term
    res = Rails.cache.fetch("users_by_#{term}", :expires_in => 1.hour.to_i) do
      query = User.find_by_term(term).page(1)
      query.collect { |user| {name: user.full_name, id: user.id.to_s, photo_url: user.image_url_or_default} }
    end
    respond_with res
  end
end