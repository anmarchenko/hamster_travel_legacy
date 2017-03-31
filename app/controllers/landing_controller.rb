# frozen_string_literal: true

class LandingController < ApplicationController
  def index; end

  def welcome
    redirect_to "/#{I18n.locale}/landing"
  end
end
