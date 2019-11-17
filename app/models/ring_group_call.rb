class RingGroupCall < ApplicationRecord
  RING_TIMEOUT = IncomingCall::RING_TIMEOUT + 3.seconds

  belongs_to :ring_group
  has_one :voicemail, as: :voicemailable, dependent: :restrict_with_error
  has_many :incoming_calls, dependent: :restrict_with_error
  has_one :answered_call,
    -> { answered },
    class_name: "IncomingCall",
    inverse_of: :ring_group_call

  validates :from_phone_number, presence: true
  validates :from_sid, presence: true

  scope :for_ring_group, ->(ring_group) { where(ring_group: ring_group) }

  delegate :voicemail_greeting, to: :ring_group
  delegate :email_voicemails?, to: :ring_group

  def self.receive(ring_group:, from:, sid:)
    call = create(ring_group: ring_group, from_phone_number: from, from_sid: sid)
    ring_group.members.available.each do |member|
      call.incoming_calls << IncomingCall.receive(user: member.user, from: from, sid: sid)
    end
    call
  end

  def owner?(user)
    ring_group.member?(user)
  end

  def greeting(voice_response)
    voice_response
  end

  def hangup
    incoming_calls.active.each { |incoming_call| EndCall.new(incoming_call).call }
    update(missed: true)
  end

  def unanswered?
    answered_call.blank?
  end
end
