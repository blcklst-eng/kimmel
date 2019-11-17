class UpdateAvailabilityMutation < Types::BaseMutation
  description "Updates the availability settings for the specified user"

  argument :id, ID, required: true
  argument :availability_input, Inputs::PatchAvailability, required: true

  field :user, Outputs::UserType, null: false
  field :errors, resolver: Resolvers::Error

  policy AvailabilityPolicy, :manage?

  def resolve
    user = User.find(input.id)
    authorize user

    if user.update_availability(availability_input)
      {user: user, errors: []}
    else
      {user: user, errors: user.errors}
    end
  end

  private

  def availability_input
    input.availability_input.to_h
  end
end
