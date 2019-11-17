class ParkParticipantMutation < Types::BaseMutation
  description "Parks a participant on hold for a user"

  argument :participant_id, ID, "The ID of the participant to transfer", required: true
  argument :user_id, ID, "The ID of the user to transfer the participant to", required: true

  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    participant = Participant.find(input.participant_id)
    authorize participant.call
    user = User.find(input.user_id)

    result = ParkParticipant.new(participant: participant, user: user).call

    if result.success?
      {success: true, errors: []}
    else
      {success: false, errors: result.errors}
    end
  end
end
