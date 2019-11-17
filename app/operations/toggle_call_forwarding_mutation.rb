class ToggleCallForwardingMutation < Types::BaseMutation
  description "Enables or disables call forwarding for a user"

  field :user, Outputs::UserType, null: true
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    current_user.toggle(:call_forwarding)

    if current_user.save
      {user: current_user, errors: []}
    else
      {user: nil, errors: current_user.errors}
    end
  end
end
