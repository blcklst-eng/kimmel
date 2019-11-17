class DeleteVoicemailMutation < Types::BaseMutation
  description "Deletes the specified voicemail"

  argument :id, ID, required: true

  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error

  policy VoicemailPolicy, :manage?

  def resolve
    voicemail = Voicemail.find(input.id)
    authorize voicemail
    voicemail.destroy

    {success: voicemail.deleted?, errors: voicemail.errors}
  end
end
