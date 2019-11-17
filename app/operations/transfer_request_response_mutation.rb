class TransferRequestResponseMutation < Types::BaseMutation
  description "Provides a response to a transfer request"

  argument :id, ID, required: true, description: "The ID of the Transfer Request"
  argument :response, String, required: true

  field :transfer_request, Outputs::TransferRequestType, null: true
  field :errors, resolver: Resolvers::Error

  policy TransferRequestPolicy, :respond?

  def resolve
    transfer_request = TransferRequest.find(input.id)
    authorize transfer_request

    if transfer_request.respond(input.response)
      {transfer_request: transfer_request, errors: []}
    else
      {transfer_request: nil, errors: transfer_request.errors}
    end
  end
end
