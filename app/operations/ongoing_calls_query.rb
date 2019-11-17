class OngoingCallsQuery < Types::BaseResolver
  description "Gets all ongoing calls for the current user"
  type [Outputs::CallType], null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Call.for_user(current_user).in_progress.latest
  end
end
