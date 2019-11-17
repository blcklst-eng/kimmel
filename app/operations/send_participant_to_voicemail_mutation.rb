class SendParticipantToVoicemailMutation < Types::BaseMutation
  description "Sends the participant to the voicemail of the specified user"

  argument :participant_id, ID, required: true
  argument :user_id, ID, required: true

  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    participant = Participant.find(input.participant_id)
    authorize participant.call
    user = User.find(input.user_id)

    result = SendParticipantToVoicemail.new(participant: participant, user: user).call

    if result.success?
      {success: true, errors: []}
    else
      {success: false, errors: result.errors}
    end
  end
end
