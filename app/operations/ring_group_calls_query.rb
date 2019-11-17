class RingGroupCallsQuery < Types::BaseResolver
  description "Get all ring group calls for the specified ring group"
  argument :ring_group_id, ID, required: true
  type Outputs::RingGroupCallType.connection_type, null: false
  policy RingGroupPolicy, :view?

  def resolve
    ring_group = RingGroup.find(input.ring_group_id)
    authorize ring_group

    RingGroupCall.for_ring_group(ring_group).latest
  end
end
