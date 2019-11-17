class MergeCallMutation < Types::BaseMutation
  description "Merge participants from one call into another"

  argument :from_call_id, ID, "The ID of the call to move participants from", required: true
  argument :to_call_id, ID, "The ID of the call to move participants to", required: true

  field :participants,
    [Outputs::ParticipantType],
    description: "The participants that were merged",
    null: true
  field :failed_participants,
    [Outputs::ParticipantType],
    description: "The participants that failed to merge",
    null: true
  field :errors, resolver: Resolvers::Error

  policy CallPolicy, :manage?

  def resolve
    from = find_and_authorize_call(input.from_call_id)
    to = find_and_authorize_call(input.to_call_id)

    result = MergeCall.new(from: from, to: to).call

    {
      participants: result.participants,
      failed_participants: result.failed_participants,
      errors: result.errors,
    }
  end

  def find_and_authorize_call(id)
    Call.find(id).tap { |call| authorize call }
  end
end
