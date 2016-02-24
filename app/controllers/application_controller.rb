class ApplicationController < ActionController::Base

  CACHE_RATES = "#{Rails.root}/lib/ecb_rates.xml"

  layout 'main'

  before_action :set_locale
  def set_locale
    I18n.locale = params[:locale] || current_user.try(:locale) || I18n.default_locale
  end

  before_action :load_exchange_rates
  def load_exchange_rates
    @bank = Money.default_bank
    if !@bank.rates_updated_at || @bank.rates_updated_at < Time.now - 1.days
      rates = ExchangeRate.current
      if rates
        @bank.update_rates_from_s(rates.eu_file)
      else
        @bank.update_rates(CACHE_RATES)
      end
    end
  end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_action :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  before_action :configure_permitted_parameters, if: :devise_controller?
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
