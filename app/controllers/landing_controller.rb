# frozen_string_literal: true
class LandingController < ApplicationController
  def index
    @hide_footer = true
  end

  def welcome
    redirect_to "/#{I18n.locale}/landing"
  end
end
