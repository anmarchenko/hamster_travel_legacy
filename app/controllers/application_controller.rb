class ApplicationController < ActionController::Base

  layout 'main'

  before_filter :set_locale
  def set_locale
    I18n.locale = params[:locale] || current_user.try(:locale) || I18n.default_locale
  end

  before_filter :load_exchange_rates
  def load_exchange_rates
    cache = "#{Rails.root}/lib/ecb_rates.xml"
    @bank = Money.default_bank
    if !@bank.rates_updated_at || @bank.rates_updated_at < Time.now - 1.days
      p "Loading exchange rates from ECB..."
      @bank.save_rates(cache)
      @bank.update_rates(cache)
      p "Exchange rates are loaded."
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  before_filter :configure_permitted_parameters, if: :devise_controller?
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name
    devise_parameter_sanitizer.for(:account_update) << :first_name << :last_name
  end

  def no_access
    flash[:error] = t('errors.unathorized')
    redirect_to('/', locale: params[:locale])
  end

  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end

end
