require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_record/railtie"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Travel
  class Application < Rails::Application
    Bundler.require(*Rails.groups)
    ::Config::Integration::Rails::Railtie.preload

    I18n.enforce_available_locales = true
    I18n.default_locale = :en

    config.action_view.field_error_proc = Proc.new { |html_tag, _instance|
      "<div class=\"has-error\">#{html_tag}</div>".html_safe
    }
    config.middleware.delete "Rack::Lock"

    config.generators do |g|
      g.orm :active_record
    end
  end
end
