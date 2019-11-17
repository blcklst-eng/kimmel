class ReadConversationMutation < Types::BaseMutation
  description "Marks a conversation as read"

  argument :id, ID, required: true

  field :conversation, Outputs::ConversationType, null: true
  field :errors, resolver: Resolvers::Error

  policy ConversationPolicy, :view?

  def resolve
    conversation = Conversation.find(input.id)
    authorize conversation

    if conversation.read_messages
      {conversation: conversation, errors: []}
    else
      {conversation: nil, errors: conversation.errors}
    end
  end
end
