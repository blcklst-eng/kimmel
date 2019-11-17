class RejoinCallMutation < Types::BaseMutation
  description "Reconnects the current user to the specified call"

  argument :call_id, ID, required: true

  field :call, Outputs::CallType, null: true
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    call = Call.find(input.call_id)
    authorize call

    result = RejoinCall.new(user: current_user, call: call).call

    if result.success?
      {call: call, errors: []}
    else
      {call: nil, errors: result.errors}
    end
  end
end
