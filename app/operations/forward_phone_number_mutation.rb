class ForwardPhoneNumberMutation < Types::BaseMutation
  description "Reassigns the phone number to the specified user and turns on forwarding"

  argument :id, ID, "The id of the phone number to forward", required: true
  argument :user_id, ID, "The id of the user to forward the number to", required: true

  field :phone_number, Outputs::PhoneNumberObjectType, null: true
  field :errors, resolver: Resolvers::Error

  policy PhoneNumberPolicy, :manage?

  def authorized_resolve
    phone_number = PhoneNumber.find(input.id)
    user = User.find(input.user_id)

    if phone_number.forward_to(user)
      {phone_number: phone_number, errors: []}
    else
      {phone_number: nil, errors: result.errors}
    end
  end
end
