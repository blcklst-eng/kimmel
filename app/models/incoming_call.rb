class IncomingCall < Call
  RING_TIMEOUT = 15

  belongs_to :ring_group_call, optional: true
  has_one :voicemail, as: :voicemailable, dependent: :restrict_with_error
  has_one :transfer_request,
    dependent: :restrict_with_error,
    foreign_key: :request_call_id,
    inverse_of: :request_call

  delegate :email_voicemails?, to: :user

  def self.receive(user:, from:, sid:)
    create(user: user).tap do |call|
      call.add_participant(phone_number: from, sid: sid)
    end
  end

  def missed?
    in_state?(:no_answer, :busy, :failed, :canceled)
  end

  def router
    if from_ring_group?
      RouteRingGroupCall
    else
      RouteIncomingCall
    end
  end

  def from_phone_number
    original_participant.phone_number
  end

  def to_phone_number
    user.phone_number
  end

  def from_sid
    original_participant&.sid
  end

  def greeting(voice_response)
    voice_response
  end

  private

  def from_ring_group?
    ring_group_call.present?
  end
end
