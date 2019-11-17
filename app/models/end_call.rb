class EndCall
  def initialize(call, adapter: TwilioAdapter.new)
    @call_to_end = call
    @adapter = adapter
  end

  def call
    return Result.failure("Cannot end a call that is not active") unless call_to_end.active?

    if end_call
      mark_participants_as_complete
      Result.success(call: call_to_end)
    else
      Result.failure("Failed to end call")
    end
  end

  private

  attr_reader :call_to_end, :adapter

  def end_call
    if call_to_end.in_state?(:initiated)
      cancel_call
    else
      end_conference
    end
  end

  def end_conference
    result = adapter.end_conference(call_to_end.conference_sid)
    call_to_end.transition_to(:completed) if result
    result
  end

  def cancel_call
    result = adapter.cancel_call(call_to_end.sid)

    if result
      call_to_end.transition_to(:canceled)
      disconnect_all_participants
    end

    result
  end

  def disconnect_all_participants
    call_to_end.participants.each do |participant|
      adapter.end_call(participant.sid)
    end
  end

  def mark_participants_as_complete
    call_to_end.participants.active.each(&:completed!)
  end
end
