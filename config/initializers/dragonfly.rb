require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "98a7a2a35b3960d6b46420dbec70e5b415518f3b75d19d5a2033943f4c7320d7"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware
