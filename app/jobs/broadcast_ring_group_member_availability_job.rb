class BroadcastRingGroupMemberAvailabilityJob < ApplicationJob
  queue_as :default

  def perform(member_id)
    member = RingGroupMember.find(member_id)
    trigger_subscription(member)
  end

  private

  def trigger_subscription(member)
    MessagingSchema.subscriptions.trigger(
      "ringGroupMemberAvailability",
      {ring_group_id: member.ring_group_id},
      member
    )
  end
end
