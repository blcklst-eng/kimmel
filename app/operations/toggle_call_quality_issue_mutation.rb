class ToggleCallQualityIssueMutation < Types::BaseMutation
  description "Toggles whether a user reported call quality issues"

  argument :call_id, ID, required: true

  field :call, Outputs::CallType, null: true
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?
  policy CallPolicy, :manage?

  def resolve
    call = Call.find(input.call_id)
    authorize call

    if call.update(quality_issue: !call.quality_issue)
      {call: call, errors: []}
    else
      {call: nil, errors: call.errors}
    end
  end
end
