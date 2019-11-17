class UpdateContactMutation < Types::BaseMutation
  description "Updates the specified contact"

  argument :id, ID, required: true
  argument :contact_input, Inputs::PatchContact, required: true

  field :contact, Outputs::ContactType, null: true
  field :errors, resolver: Resolvers::Error

  policy ContactPolicy, :manage?

  def resolve
    authorize contact
    result = UpdateContact.new(contact: contact, params: contact_input).call

    if result.success?
      {contact: result.contact, errors: []}
    else
      {contact: nil, errors: result.errors}
    end
  end

  private

  def contact
    @contact ||= Contact.find(input.id)
  end

  def contact_input
    input.contact_input.to_h
  end
end
