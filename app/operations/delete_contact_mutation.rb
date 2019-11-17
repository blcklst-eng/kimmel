class DeleteContactMutation < Types::BaseMutation
  description "Removes the specified contact from the saved list"

  argument :id, ID, required: true

  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error

  policy ContactPolicy, :manage?

  def resolve
    contact = Contact.find(input.id)
    authorize contact

    if contact.remove_from_saved
      {success: true, errors: []}
    else
      {success: false, errors: contact.errors}
    end
  end
end
