class CreateTransferRequestMutation < Types::BaseMutation
  description "Initiates a transfer request to a user"

  argument :user_id, ID, required: true
  argument :participant_id, ID, required: true

  field :transfer_request, Outputs::TransferRequestType, null: true
  field :errors, resolver: Resolvers::Error

  def resolve
    participant = Participant.find(input.participant_id)
    user = User.find(input.user_id)

    result = CreateTransferRequest.new(participant: participant, receiver: user).call

    if result.success?
      {transfer_request: result.transfer_request, errors: []}
    else
      {transfer_request: nil, errors: result.errors}
    end
  end
end
