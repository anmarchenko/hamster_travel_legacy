class ApplicationController < ActionController::Base

  before_filter :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale # || current_user.default_locale # before I18n
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  layout 'main'
end
