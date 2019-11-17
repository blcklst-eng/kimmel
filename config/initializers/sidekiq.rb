Sidekiq.configure_server do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL") { "locahost:6379" },
    namespace: "sidekiq_messaging_#{Rails.env}",
    network_timeout: 5,
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch("REDIS_URL") { "locahost:6379" },
    namespace: "sidekiq_messaging_#{Rails.env}",
    network_timeout: 5,
  }
end
