class RingGroupCallTimeoutJob < ApplicationJob
  queue_as :default

  def perform(ring_group_call_id)
    ring_group_call = RingGroupCall.find(ring_group_call_id)
    RingGroupCallTimeout.new(ring_group_call).call
  end
end
