class VoicemailQuery < Types::BaseResolver
  description "Gets the specified voicemail"
  argument :id, ID, required: true
  type Outputs::VoicemailType, null: true
  policy VoicemailPolicy, :view?

  def resolve
    Voicemail.find(input.id).tap { |voicemail| authorize voicemail }
  end
end
