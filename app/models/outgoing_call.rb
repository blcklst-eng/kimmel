class OutgoingCall < Call
  RING_TIMEOUT = 60

  def self.make(user:, to:, sid:)
    create(user: user, sid: sid).tap do |call|
      call.add_participant(phone_number: to)
    end
  end

  def missed?
    false
  end

  def router
    RouteOutgoingCall
  end

  def to_phone_number
    original_participant.phone_number
  end

  def from_phone_number
    user.phone_number
  end

  def greeting(voice_response)
    voice_response.play(url: AssetHelper.url("audio/one-moment-please.wav"))
  end
end
