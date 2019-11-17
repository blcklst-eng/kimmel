class SendMessage
  def initialize(to:, from:, body:, media: [], messenger: TwilioAdapter.new)
    @to = to
    @from = from
    @body = body
    @media = media
    @messenger = messenger
  end

  def call
    return Result.failure("Invalid phone number") unless to.valid?

    result = create_message
    return result unless result.success?

    delivery = send_message(result.message)
    if delivery.sent?
      result
    else
      Result.failure(delivery.error)
    end
  end

  private

  attr_reader :to, :from, :body, :media, :messenger

  def create_message
    Message.transaction do
      contact = Contact.from(phone_number: to.phone_number, user: from)
      conversation = Conversation.find_or_create_by!(contact: contact, user: from)
      message = OutgoingMessage.create!(conversation: conversation, body: body, media: media)
      Result.success(message: message, conversation: conversation, contact: contact)
    end
  rescue ActiveRecord::RecordInvalid => e
    Result.failure(e.record.errors)
  end

  def send_message(message)
    messenger.send_message(
      to: message.to,
      from: message.from,
      body: message.body,
      status_url: message.status_url,
      media_url: message.media.map { |media| RouteHelper.rails_blob_url(media) }
    )
  end
end
