class RingGroupCallQuery < Types::BaseResolver
  description "Get the specified ring group call"
  argument :id, ID, required: true
  type Outputs::RingGroupCallType, null: false
  policy RingGroupPolicy, :view?

  def resolve
    RingGroupCall.find(input.id).tap { |call| authorize call.ring_group }
  end
end
