class PublishPushNotificationsForMessage
  def initialize(message, client: TwilioNotifyAdapter.new)
    @message = message
    @client = client
  end

  def call
    client.send(notification)
  end

  private

  attr_reader :message, :client

  def notification
    {
      to: message.user_id,
      title: message.contact.identity,
      body: message.body,
      badge: Conversation.for_user(message.user).unread_count,
      data: {
        conversation: message.conversation_id,
      },
    }
  end
end
