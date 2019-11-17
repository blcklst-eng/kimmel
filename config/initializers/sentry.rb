Raven.configure do |config|
  config.dsn = Rails.application.credentials[:sentry_dsn]
  config.environments = %w[production staging]
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.silence_ready = true
end
