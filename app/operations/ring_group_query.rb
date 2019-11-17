class RingGroupQuery < Types::BaseResolver
  description "Get the specified ring group"
  argument :id, ID, required: true
  type Outputs::RingGroupType, null: false
  policy RingGroupPolicy, :view?

  def resolve
    RingGroup.find(input.id).tap { |ring_group| authorize ring_group }
  end
end
