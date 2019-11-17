class RingbackToneResponse
  RINGBACK_TONE_PATH = "audio/ringback.wav"

  def initialize
    @response = Twilio::TwiML::VoiceResponse.new
  end

  def to_s
    @response.play(url: AssetHelper.url(RINGBACK_TONE_PATH)).to_s
  end
end
