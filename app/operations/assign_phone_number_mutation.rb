class AssignPhoneNumberMutation < Types::BaseMutation
  description "Assigns a phone number to the specifed user"

  argument :user_id, ID, required: true
  argument :phone_number_id, ID, required: false

  field :user, Outputs::UserType, null: true
  field :errors, resolver: Resolvers::Error

  policy UserPolicy, :manage?

  def authorized_resolve
    result = AssignPhoneNumber.new(user: user, phone_number: phone_number).call

    if result.success?
      {user: result.user, errors: []}
    else
      {user: nil, errors: result.errors}
    end
  end

  private

  def user
    User.find(input.user_id)
  end

  def phone_number
    PhoneNumber.find_by(id: input.phone_number_id)
  end
end
