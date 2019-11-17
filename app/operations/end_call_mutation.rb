class EndCallMutation < Types::BaseMutation
  description "Ends the specified call"

  argument :call_id, ID, required: true

  field :success, Boolean, null: false
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    call = Call.find(input.call_id)
    authorize call
    result = EndCall.new(call).call

    if result.success?
      {success: true, errors: []}
    else
      {success: false, errors: result.errors}
    end
  end
end
