class UnreadConversationsQuery < Types::BaseResolver
  description "Gets all unread conversations for the current user"
  type Outputs::ConversationType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Conversation.unread.for_user(current_user)
  end
end
