class ReceiveRingGroupCall
  def initialize(to:, from:, sid:)
    @ring_group = to.ring_group
    @from = from
    @sid = sid
  end

  def call
    return Result.failure("Invalid to number") unless ring_group

    ring_group_call = RingGroupCall.receive(ring_group: ring_group, from: from, sid: sid)

    if connect_members_to_call(ring_group_call)
      manage_call_timeout(ring_group_call)
      Result.success(response: QueueCallResponse.new(call: ring_group_call).to_s)
    else
      ring_group_call.update(missed: true)
      Result.success(response: VoicemailResponse.new(ring_group_call).to_s)
    end
  end

  private

  attr_reader :ring_group, :from, :sid

  def connect_members_to_call(ring_group_call)
    ring_group_call.incoming_calls.map { |incoming_call|
      DialUserIntoIncomingCall.new(incoming_call).call.success?
    }.include?(true)
  end

  def manage_call_timeout(ring_group_call)
    RingGroupCallTimeoutJob.set(wait: RingGroupCall::RING_TIMEOUT).perform_later(ring_group_call.id)
  end
end
