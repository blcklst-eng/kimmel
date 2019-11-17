class EndParticipantCallMutation < Types::BaseMutation
  description "End the participant's call leg"

  argument :participant_id, ID, required: true

  field :participant, Outputs::ParticipantType, null: true
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    participant = Participant.active.find(input.participant_id)
    authorize participant.call

    result = EndParticipantCall.new(participant).call

    if result.success?
      {participant: result.participant, errors: []}
    else
      {participant: nil, errors: result.errors}
    end
  end
end
