class RouteOutgoingCall
  def initialize(call:, status:, adapter: TwilioAdapter.new)
    @outgoing_call = call
    @status = status
    @adapter = adapter
  end

  def call
    if status.no_answer?
      status.apply(outgoing_call)
      adapter.end_call(outgoing_call.sid)
    elsif status.answered?
      connect_call_to_conference
    end
  end

  private

  attr_reader :outgoing_call, :status, :adapter

  def connect_call_to_conference
    ConnectCallToConference.new(call: outgoing_call, sids: [outgoing_call.sid]).call
  end
end
