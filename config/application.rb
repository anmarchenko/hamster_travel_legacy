# frozen_string_literal: true

require_relative 'boot'
# Pick the frameworks you want:
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Travel
  class Application < Rails::Application
    Bundler.require(*Rails.groups)

    Config::Integrations::Rails::Railtie.preload

    I18n.enforce_available_locales = true
    I18n.default_locale = :en

    config.exceptions_app = routes

    config.action_view.field_error_proc = proc { |html_tag, _instance|
      "<div class=\"has-error\">#{html_tag}</div>".html_safe
    }
    config.middleware.delete Rack::Lock

    config.generators do |g|
      g.orm :active_record
    end

    config.autoload_paths << Rails.root.join('lib', 'accounts')
    config.autoload_paths << Rails.root.join('lib', 'travels')
    config.autoload_paths << Rails.root.join('lib', 'exchange_rates')
  end
end
