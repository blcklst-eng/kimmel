class RecordingsQuery < Types::BaseResolver
  description "Gets all recordings for the current user"
  type Outputs::RecordingType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Recording.for_user(current_user).recorded.latest
  end
end
