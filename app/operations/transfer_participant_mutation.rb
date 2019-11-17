class TransferParticipantMutation < Types::BaseMutation
  description "Places the participant into a new call to a specified user"

  argument :participant_id, ID, required: true
  argument :user_id, ID, required: true

  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    participant = Participant.find(input.participant_id)
    authorize participant.call
    user = User.find(input.user_id)

    result = TransferParticipantToUser.new(participant: participant, user: user).call

    if result.success?
      {success: true, errors: []}
    else
      {success: false, errors: result.errors}
    end
  end
end
