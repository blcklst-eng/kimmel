class SendMessageFromWalter
  def initialize(contact_args:, body:, user_walter_id:, adapter: TwilioAdapter.new)
    @contact_args = contact_args
    @body = body
    @user_walter_id = user_walter_id

    @adapter = adapter
  end

  def call
    return Result.failure("Invalid User Walter ID") unless user

    SendMessage.new(send_message_args).call.tap do |result|
      update_contact(result.contact) if result.success?
    end
  end

  private

  attr_reader :adapter, :contact_args, :to, :body, :user_walter_id

  def send_message_args
    {
      to: lookup,
      from: user,
      body: body,
      messenger: adapter,
    }
  end

  def update_contact(contact)
    contact.update(update_contact_args)
  end

  def update_contact_args
    contact_args
      .slice(:first_name, :last_name, :walter_id)
      .merge(saved: true)
  end

  def lookup
    @lookup ||= adapter.lookup(contact_args[:phone_number])
  end

  def user
    User.find_by(walter_id: user_walter_id)
  end
end
