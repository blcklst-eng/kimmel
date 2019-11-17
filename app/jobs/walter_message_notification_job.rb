class WalterMessageNotificationJob < ApplicationJob
  queue_as :default

  def perform(message)
    endpoint = Rails.application.config.try(:walter_notification_endpoint)
    HTTP.post(endpoint, params: walter_params(message)) if endpoint
  end

  private

  def walter_params(message)
    {
      contact_walter_id: message.contact.walter_id,
      first_name: message.contact.first_name,
      last_name: message.contact.last_name,
      to: message.to,
      body: message.body,
      user_walter_id: message.user.walter_id,
      type: message.type,
    }
  end
end
