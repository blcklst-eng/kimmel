class EndUnansweredRingGroupCalls
  def initialize(answered_call:, adapter: TwilioAdapter.new)
    @answered_call = answered_call
    @adapter = adapter
  end

  def call
    return Result.failure("Cannot end a call that is not active") unless answered_call.active?

    results = other_ring_group_calls.map { |other_call| end_call(other_call) }

    if results.include?(false)
      Result.failure("Could not end all calls")
    else
      Result.success(ended_calls: other_ring_group_calls)
    end
  end

  private

  attr_reader :answered_call, :adapter

  def other_ring_group_calls
    @other_ring_group_calls ||= IncomingCall
      .where(ring_group_call: answered_call.ring_group_call)
      .where.not(id: answered_call.id)
  end

  def end_call(other_call)
    if adapter.cancel_call(other_call.sid)
      other_call.transition_to(:canceled)
      true
    else
      false
    end
  end
end
