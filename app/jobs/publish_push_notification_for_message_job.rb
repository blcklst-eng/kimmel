class PublishPushNotificationForMessageJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    PublishPushNotificationsForMessage.new(message).call
  end
end
