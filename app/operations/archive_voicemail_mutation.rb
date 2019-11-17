class ArchiveVoicemailMutation < Types::BaseMutation
  description "Marks a voicemail to be archived rather than deleted"

  argument :id, ID, required: true

  field :voicemail, Outputs::VoicemailType, null: true
  field :errors, resolver: Resolvers::Error

  policy VoicemailPolicy, :manage?

  def resolve
    voicemail = Voicemail.find(input.id)
    authorize voicemail

    if voicemail.update(archived: true)
      {voicemail: voicemail, errors: []}
    else
      {voicemail: nil, errors: voicemail.errors}
    end
  end
end
