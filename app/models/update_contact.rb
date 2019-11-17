class UpdateContact
  def initialize(contact:, params:)
    @contact = contact
    @params = params
  end

  def call
    if updating_phone_number?
      return Result.failure("Invalid phone number") unless phone_number.valid?
    end

    if contact.update(params.merge(saved: true))
      Result.success(contact: contact)
    else
      Result.failure(contact.errors)
    end
  end

  private

  attr_reader :contact, :params, :lookup_adapter

  def updating_phone_number?
    !phone_number.nil?
  end

  def phone_number
    params[:phone_number]
  end
end
