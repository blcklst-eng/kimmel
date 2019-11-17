class CreateContact
  def initialize(params)
    @params = params
  end

  def call
    return Result.failure("Invalid phone number") unless phone_number.valid?

    contact = initialize_contact
    if contact.update(params.merge(saved: true))
      Result.success(contact: contact)
    else
      Result.failure(contact.errors)
    end
  end

  private

  attr_reader :params, :lookup_adapter

  def initialize_contact
    Contact.for_user(params[:user]).find_or_initialize_by(phone_number: phone_number.to_s)
  end

  def phone_number
    params[:phone_number]
  end
end
