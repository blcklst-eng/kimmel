class ConversationQuery < Types::BaseResolver
  description "Gets the specified conversation"
  argument :id, ID, required: true
  type Outputs::ConversationType, null: true
  policy ConversationPolicy, :view?

  def resolve
    Conversation.find(input.id).tap { |conversation| authorize conversation }
  end
end
