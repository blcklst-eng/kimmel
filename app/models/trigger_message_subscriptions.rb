class TriggerMessageSubscriptions
  def initialize(message)
    @message = message
  end

  def call
    trigger_globally(message)
    trigger_to_conversation(message)
  end

  private

  attr_accessor :message

  def trigger_globally(message)
    trigger(message)
  end

  def trigger_to_conversation(message)
    trigger(message, conversation_id: message.conversation_id)
  end

  def trigger(message, args = {})
    MessagingSchema.subscriptions.trigger(type, args, message, scope: message.user_id)
  end

  def type
    case message
    when IncomingMessage
      "messageReceived"
    when OutgoingMessage
      "messageSent"
    end
  end
end
