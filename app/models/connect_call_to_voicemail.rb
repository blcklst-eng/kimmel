class ConnectCallToVoicemail
  def initialize(incoming_call:, adapter: TwilioAdapter.new)
    @incoming_call = incoming_call
    @adapter = adapter
  end

  def call
    if connect_to_voicemail(incoming_call.from_sid)
      Result.success
    else
      Result.failure("Could not connect call to voicemail")
    end
  end

  private

  attr_reader :incoming_call, :adapter

  def connect_to_voicemail(sid)
    adapter.update_call(
      sid: sid,
      method: "GET",
      url: RouteHelper.voicemail_create_url(incoming_call)
    )
  end
end
