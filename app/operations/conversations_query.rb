class ConversationsQuery < Types::BaseResolver
  description "Gets all conversations for the current user"
  type Outputs::ConversationType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Conversation.for_user(current_user).order_by_most_recent_message
  end
end
