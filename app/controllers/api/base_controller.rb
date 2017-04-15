# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    protect_from_forgery with: :null_session

    rescue_from ActiveRecord::RecordNotFound do
      head 404
    end

    def api_authorize_readonly!
      return unless @trip.private
      head(403) && return unless user_signed_in?
      head(403) && return unless @trip.can_be_seen_by?(current_user)
    end
  end
end
