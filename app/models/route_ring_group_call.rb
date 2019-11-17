class RouteRingGroupCall
  def initialize(call:, status:)
    @incoming_call = call
    @status = status
  end

  def call
    if status.no_answer?
      status.apply(incoming_call)
    elsif status.answered?
      connect_call
    end
  end

  private

  attr_reader :incoming_call, :status

  def connect_call
    result = connect_call_to_conference

    if result.success?
      EndUnansweredRingGroupCalls.new(answered_call: incoming_call).call
    end
  end

  def connect_call_to_conference
    ConnectCallToConference.new(
      call: incoming_call,
      sids: incoming_call.participants.pluck(:sid)
    ).call
  end
end
