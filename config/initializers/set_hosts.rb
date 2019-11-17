Rails.application.routes.default_url_options[:host] = Rails.configuration.api_host
Rails.application.routes.default_url_options[:protocol] = Rails.configuration.api_protocol
Rails.application.config.action_controller.asset_host =
  "#{Rails.configuration.api_protocol}://#{Rails.configuration.api_host}"
