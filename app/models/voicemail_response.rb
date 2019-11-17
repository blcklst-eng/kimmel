class VoicemailResponse
  def initialize(incoming_call)
    @incoming_call = incoming_call
    @response = Twilio::TwiML::VoiceResponse.new
  end

  def to_s
    play_greeting
    response.record(action: RouteHelper.voicemail_store_url(incoming_call), play_beep: true)
    response.to_s
  end

  private

  attr_reader :incoming_call, :response

  def play_greeting
    if incoming_call.voicemail_greeting.attached?
      response.play(url: RouteHelper.rails_blob_url(incoming_call.voicemail_greeting))
    else
      response.say(
        <<~GREETING
          The person you are trying to reach is currently unavailable.
          Please leave a message after the tone.
        GREETING
      )
    end
  end
end
