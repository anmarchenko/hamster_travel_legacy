class ApplicationController < ActionController::Base

  layout 'main'

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

  before_filter :configure_permitted_parameters, if: :devise_controller?
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name
  end

  def no_access
    flash[:error] = t('errors.unathorized')
    redirect_to('/', locale: params[:locale])
  end

end
