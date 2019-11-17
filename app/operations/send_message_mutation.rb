class SendMessageMutation < Types::BaseMutation
  description "Sends a message to the specified number"

  argument :to, Types::PhoneNumberType, required: true
  argument :body, String, required: false
  argument :media, [Types::ActiveStorageSignedIdType], required: false, default_value: []

  field :conversation, Outputs::ConversationType, null: true
  field :message, Outputs::MessageType, null: true
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    result = SendMessage.new(send_message_args).call

    if result.success?
      {conversation: result.conversation, message: result.message, errors: []}
    else
      {conversation: nil, message: nil, errors: result.errors}
    end
  end

  private

  def send_message_args
    {
      to: input.to,
      from: current_user,
      body: input.body,
      media: input.media,
    }
  end
end
