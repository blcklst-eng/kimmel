class RouteIncomingCall
  def initialize(call:, status:)
    @incoming_call = call
    @status = status
  end

  def call
    if status.no_answer?
      status.apply(incoming_call)
      ConnectCallToVoicemail.new(incoming_call: incoming_call).call
    elsif status.answered?
      connect_call_to_conference
    end
  end

  private

  attr_reader :incoming_call, :status

  def connect_call_to_conference
    ConnectCallToConference.new(
      call: incoming_call,
      sids: incoming_call.participants.pluck(:sid)
    ).call
  end
end
