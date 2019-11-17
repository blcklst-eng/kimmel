class SetEmailVoicemailsMutation < Types::BaseMutation
  description "Sets the users setting for receiving voicemails by email"

  argument :email_voicemails, Boolean, required: true

  field :user, Outputs::UserType, null: true
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    if current_user.update(email_voicemails: input.email_voicemails)
      {user: current_user, errors: []}
    else
      {user: nil, errors: current_user.errors}
    end
  end
end
