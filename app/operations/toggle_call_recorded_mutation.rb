class ToggleCallRecordedMutation < Types::BaseMutation
  description "Toggles whether a call is recorded"

  argument :call_id, ID, required: true

  field :call, Outputs::CallType, null: true
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    call = Call.find(input.call_id)
    authorize call

    if call.toggle_recorded
      {call: call, errors: []}
    else
      {call: nil, errors: call.errors}
    end
  end
end
