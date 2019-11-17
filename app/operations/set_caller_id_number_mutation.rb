class SetCallerIdNumberMutation < Types::BaseMutation
  description "Sets the users caller id to the provided phone number"

  argument :user_id, ID, required: true
  argument :phone_number, Types::PhoneNumberType, required: true

  field :user, Outputs::UserType, null: true
  field :errors, resolver: Resolvers::Error

  policy PhoneNumberPolicy, :manage?

  def authorized_resolve
    user = User.find(input.user_id)

    if user.update(caller_id_number: input.phone_number.to_s)
      {user: user, errors: []}
    else
      {user: nil, errors: user.errors}
    end
  end
end
