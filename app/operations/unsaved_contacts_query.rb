class UnsavedContactsQuery < Types::BaseResolver
  description "Gets contacts for the current user that have not yet been saved with a name"
  type Outputs::ContactType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Contact
      .joins(:conversation)
      .where(saved: false)
      .where(user: current_user)
      .order("conversations.last_message_at desc")
  end
end
