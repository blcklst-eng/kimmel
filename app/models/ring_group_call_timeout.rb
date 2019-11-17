class RingGroupCallTimeout
  def initialize(ring_group_call)
    @ring_group_call = ring_group_call
  end

  def call
    if ring_group_call.unanswered?
      ring_group_call.update(missed: true)
      ConnectCallToVoicemail.new(incoming_call: ring_group_call).call
    end
  end

  private

  attr_reader :ring_group_call
end
