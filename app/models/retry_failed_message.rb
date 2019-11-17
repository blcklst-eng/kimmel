class RetryFailedMessage
  def initialize(message, messenger: TwilioAdapter.new)
    @message = message
    @messenger = messenger
  end

  def call
    return Result.failure("Cannot retry messages that have not failed") unless message.failed?

    new_message = create_message
    result = send_message(new_message)

    if result.sent?
      message.destroy
      Result.success(message: new_message)
    else
      Result.failure(result.error)
    end
  end

  private

  attr_reader :message, :messenger

  def create_message
    OutgoingMessage.create(conversation: message.conversation, body: message.body)
  end

  def send_message(message)
    messenger.send_message(
      to: message.to,
      from: message.from,
      body: message.body,
      status_url: message.status_url
    )
  end
end
