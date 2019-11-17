class CreateContactMutation < Types::BaseMutation
  description "Create a new contact"

  argument :contact_input, Inputs::Contact, required: true

  field :contact, Outputs::ContactType, null: true
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    result = CreateContact.new(contact_args).call

    if result.success?
      {contact: result.contact, errors: []}
    else
      {contact: nil, errors: result.errors}
    end
  end

  private

  def contact_args
    input.contact_input.to_h.merge(user: current_user)
  end
end
