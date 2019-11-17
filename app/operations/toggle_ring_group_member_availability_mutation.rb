class ToggleRingGroupMemberAvailabilityMutation < Types::BaseMutation
  description "Changes the availability setting for the current user for the specified membership"

  argument :member_id, ID, required: true

  field :ring_group_member, Outputs::RingGroupMemberType, null: true
  field :errors, resolver: Resolvers::Error

  policy ApplicationPolicy, :logged_in?

  def authorized_resolve
    member = RingGroupMember.where(user: current_user).find(input.member_id)
    member.toggle(:available)

    if member.save
      {ring_group_member: member, errors: []}
    else
      {ring_group_member: nil, errors: member.errors}
    end
  end
end
