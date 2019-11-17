class ReceiveMessage
  def initialize(to:, from:, body:, media_urls: [])
    @user = User.by_number(to)
    @from = from
    @body = body
    @media_urls = media_urls
  end

  def call
    return Result.failure("Invalid to number") unless user

    message = build_message

    if message.save
      analyze_media(message)
      conversation.message_received
      Result.success
    else
      Result.failure(message.errors)
    end
  end

  private

  attr_reader :user, :from, :body, :media_urls, :downloader

  def build_message
    IncomingMessage.new(conversation: conversation, body: body).tap do |message|
      message.attach_remote_media(media_urls)
    end
  end

  def analyze_media(message)
    message.media.each(&:analyze)
  end

  def conversation
    @conversation ||= Conversation.find_or_create_by(contact: contact, user: user)
  end

  def contact
    Contact.from(phone_number: from, user: user)
  end
end
