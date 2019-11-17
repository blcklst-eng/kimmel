class RingGroup < ApplicationRecord
  has_one :number,
    as: :assignable,
    class_name: "PhoneNumber",
    dependent: :nullify,
    inverse_of: :assignable
  has_many :members, dependent: :restrict_with_error, class_name: "RingGroupMember"
  has_many :users, through: :members
  has_many :ring_group_calls,
    -> { latest },
    inverse_of: :ring_group,
    dependent: :restrict_with_error
  has_many :voicemails, -> { latest }, through: :ring_group_calls
  has_one_attached :voicemail_greeting

  validates_with VoicemailGreetingFormatValidator

  def email_voicemails?
    false
  end

  def phone_number
    number&.number
  end

  def receive_incoming_call(to:, from:, sid:)
    ReceiveRingGroupCall.new(to: to, from: from, sid: sid).call
  end

  def receive_transfer_request_call(*)
    Result.failure("Cannot transfer to a Ring Group")
  end

  def available?
    members.any?(&:available?)
  end

  def member?(user)
    users.include?(user)
  end

  def last_communication_at
    ring_group_calls.latest.first&.created_at
  end
end
