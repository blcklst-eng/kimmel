class InvalidPhoneNumberResponse
  def initialize
    @response = Twilio::TwiML::VoiceResponse.new
  end

  def to_s
    @response.say(
      "Your call cannot be completed as dialed. Please check the number and dial again.",
      voice: "Polly.Joanna"
    ).to_s
  end
end
