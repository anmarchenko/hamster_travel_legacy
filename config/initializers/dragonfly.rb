require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "98a7a2a35b3960d6b46420dbec70e5b415518f3b75d19d5a2033943f4c7320d7"

  url_format "/media/:job/:name"

  if Rails.env.development? || Rails.env.test?
    datastore :file,
      root_path: Rails.root.join('public/system/dragonfly', Rails.env),
      server_root: Rails.root.join('public')
  else
    datastore :s3,
      bucket_name: 'hamster-travel-uploads',
      access_key_id: Rails.application.secrets.s3_key,
      secret_access_key: Rails.application.secrets.s3_secret,
      url_scheme: 'https'
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# patch S3 utf-8 characters problem
module Dragonfly
  class S3DataStore
    def meta_to_headers(meta)
      {'x-amz-meta-json' => JSON.generate(meta, ascii_only: true)}
    end
  end
end
