class BroadcastMessageStatusChangedJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    MessagingSchema.subscriptions.trigger(
      "messageStatusChanged",
      {message_id: message.id},
      message,
      scope: message.user_id
    )
  end
end
