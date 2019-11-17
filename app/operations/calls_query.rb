class CallsQuery < Types::BaseResolver
  description "Gets all calls for the current user"
  argument :missed, Boolean, "Filter by missed calls", required: false
  type Outputs::CallType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Call.for_user(current_user).filter_by(filter_args).latest
  end

  private

  def filter_args
    {missed: input.missed}.compact
  end
end
