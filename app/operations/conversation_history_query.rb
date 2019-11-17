class ConversationHistoryQuery < Types::BaseResolver
  description "Searches for any past conversation history with a specific phone number"
  argument :phoneNumber,
    Types::PhoneNumberType,
    description: "A phone number for a existing contact",
    required: true
  type Outputs::ConversationType.connection_type, null: true
  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    Conversation.with_contact_phone_number(input.phone_number.to_s)
  end
end
