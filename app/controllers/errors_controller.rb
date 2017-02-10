# frozen_string_literal: true
class ErrorsController < ApplicationController
  def not_found
    render status: 404
  end

  def no_access
    render status: 403
  end
end
