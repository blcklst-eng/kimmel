class RemoveContactFromSavedMutation < Types::BaseMutation
  description "Removes the specified contact from the saved list"

  argument :id, ID, required: true

  field :contact, Outputs::ContactType, null: true
  field :errors, resolver: Resolvers::Error

  policy ContactPolicy, :manage?

  def resolve
    contact = Contact.find(input.id)
    authorize contact

    if contact.remove_from_saved
      {contact: contact, errors: []}
    else
      {contact: nil, errors: contact.errors}
    end
  end
end
