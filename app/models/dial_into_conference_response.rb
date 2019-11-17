class DialIntoConferenceResponse
  def initialize(call)
    @call = call
    @response = Twilio::TwiML::VoiceResponse.new
  end

  def to_s
    response.dial { |dial|
      dial.conference(call.id, **conference_args)
    }.to_s
  end

  private

  attr_reader :call, :response

  def conference_args
    {
      beep: false,
      start_conference_on_enter: true,
      end_conference_on_exit: false,
      status_callback: RouteHelper.call_status_url,
      status_callback_event: "start end join leave mute hold",
      record: "record-from-start",
      recording_status_callback: RouteHelper.recording_url(call.id),
    }
  end
end
