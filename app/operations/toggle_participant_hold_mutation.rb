class ToggleParticipantHoldMutation < Types::BaseMutation
  description "Places and removes a participant from hold"

  argument :participant_id, ID, required: true

  field :participant, Outputs::ParticipantType, null: true
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    participant = Participant.find(input.participant_id)
    authorize participant.call

    result = ToggleHoldForConferenceParticipant.new(participant).call

    if result.success?
      {participant: participant, errors: []}
    else
      {participant: nil, errors: result.errors}
    end
  end
end
