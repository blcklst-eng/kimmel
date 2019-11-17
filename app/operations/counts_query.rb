class CountsQuery < Types::BaseResolver
  description "Gets counts for unread conversations, new voicemails, and missed calls"
  type Outputs::CountsType, null: true
  policy ApplicationPolicy, :logged_in?

  def resolve
    current_user
  end
end
