class CallTokenQuery < Types::BaseResolver
  description "Provides a token with incoming and outgoing call capability"
  type String, null: false
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    TwilioCapabilityTokenGenerator.new(current_user.id).call
  end
end
