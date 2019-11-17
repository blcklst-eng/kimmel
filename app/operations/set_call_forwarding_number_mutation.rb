class SetCallForwardingNumberMutation < Types::BaseMutation
  description "Sets the users call forwarding number"

  argument :number, Types::PhoneNumberType, required: true

  field :user, Outputs::UserType, null: true
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    if current_user.update(call_forwarding_number: input.number.to_s)
      {user: current_user, errors: []}
    else
      {user: nil, errors: current_user.errors}
    end
  end
end
