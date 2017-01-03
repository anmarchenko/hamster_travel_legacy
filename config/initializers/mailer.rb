unless Rails.env.test?
  Rails.configuration.action_mailer.delivery_method = :smtp
  Rails.configuration.action_mailer.smtp_settings = {
    address:              Settings.smtp.address,
    port:                 Settings.smtp.port,
    user_name:            Settings.smtp.username,
    password:             Settings.smtp.password,
    authentication:       Settings.smtp.authentication,
    enable_starttls_auto: Settings.smtp.enable_starttls_auto
  }

  # log action_mailer messages to separate file with severity INFO to prevent log file from getting too big
  Rails.configuration.action_mailer.logger = ActiveSupport::Logger.new('log/mailer.log')
  Rails.configuration.action_mailer.logger.level = ActiveSupport::Logger::Severity::INFO
end
