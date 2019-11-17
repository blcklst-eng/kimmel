class RetryFailedMessageMutation < Types::BaseMutation
  description "Retries a failed message"

  argument :id, ID, required: true

  field :conversation, Outputs::ConversationType, null: true
  field :message, Outputs::MessageType, null: true
  field :errors, resolver: Resolvers::Error

  policy MessagePolicy, :retry?

  def resolve
    authorize message
    result = RetryFailedMessage.new(message).call

    if result.success?
      {conversation: result.message.conversation, message: result.message, errors: []}
    else
      {conversation: nil, message: nil, errors: result.errors}
    end
  end

  private

  def message
    @message ||= OutgoingMessage.find(input.id)
  end
end
