class RecordRingGroupVoicemailGreetingMutation < Types::BaseMutation
  description "Saves the provided audio as the voicemail greeting message for the ring group"

  argument :ring_group_id, ID, required: true
  argument :audio,
    Types::ActiveStorageSignedIdType,
    description: "The signed id of the audio file",
    required: true

  field :ring_group, Outputs::RingGroupType, null: true
  field :errors, resolver: Resolvers::Error

  policy RingGroupPolicy, :manage?

  def resolve
    ring_group = RingGroup.find(input.ring_group_id)
    authorize ring_group

    if ring_group.update(voicemail_greeting: input.audio)
      {ring_group: ring_group, errors: []}
    else
      {ring_group: nil, errors: ring_group.errors}
    end
  end
end
