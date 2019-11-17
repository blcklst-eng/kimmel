class ContactQuery < Types::BaseResolver
  description "Gets the specified contact"
  argument :id, ID, required: true
  type Outputs::ContactType, null: true
  policy ContactPolicy, :view?

  def resolve
    Contact.find(input.id).tap { |contact| authorize contact }
  end
end
