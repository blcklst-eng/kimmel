class VoicemailsQuery < Types::BaseResolver
  description "Gets all voicemails for the current user"
  argument :archived, Boolean, "Filter by archived", required: false
  type Outputs::VoicemailType.connection_type, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    current_user.voicemails.filter_by(filter_args).latest
  end

  private

  def filter_args
    {archived: input.archived}.compact
  end
end
