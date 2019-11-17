class User < ApplicationRecord
  belongs_to :screener_number, optional: true, class_name: "PhoneNumber"
  has_one :number,
    -> { forwarding(false) },
    as: :assignable,
    class_name: "PhoneNumber", dependent: :nullify, inverse_of: :assignable
  has_many :forwarding_numbers,
    -> { forwarding },
    as: :assignable,
    class_name: "PhoneNumber",
    inverse_of: :assignable
  has_many :conversations, dependent: :nullify
  has_many :messages, through: :conversations
  has_many :calls, dependent: :restrict_with_error
  has_many :incoming_calls, dependent: :restrict_with_error
  has_many :in_progress_calls,
    -> { in_progress },
    class_name: "Call",
    inverse_of: :user,
    dependent: :restrict_with_error

  has_many :voicemails, through: :incoming_calls, source: :voicemail
  has_many :ring_group_memberships, dependent: :restrict_with_error, class_name: "RingGroupMember"
  has_one_attached :voicemail_greeting

  validates :origin_id, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :walter_id, allow_nil: true, numericality: {only_integer: true, greater_than: 0}
  validates :intranet_id, allow_nil: true, numericality: {only_integer: true, greater_than: 0}
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :call_forwarding_number, presence: true, if: -> { call_forwarding? }
  validates_with VoicemailGreetingFormatValidator

  after_commit :broadcast_availability

  searchkick callbacks: :async, text_middle: [:full_name], word: [:id]

  scope :with_number, -> { includes(:number).where.not(phone_numbers: {number: nil}) }
  scope :order_by_name, -> { order(Arel.sql("COALESCE(last_name, first_name)"), first_name: :asc) }

  def self.by_number(phone_number)
    PhoneNumber.find_by(number: phone_number)&.user
  end

  def active_calls?
    calls.active.exists?
  end

  def search_data
    {full_name: full_name, id: id, phone_number: phone_number}
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def phone_number
    number&.number
  end

  def outgoing_number(call)
    if call.internal?
      phone_number
    else
      caller_id
    end
  end

  def client
    "client:#{id}"
  end

  def incoming_connection
    return call_forwarding_number if call_forwarding?

    client
  end

  def guest?
    false
  end

  def admin?
    can?(:manage_messaging)
  end

  def see_calling?
    can?(:see_calling)
  end

  def number?
    number.present?
  end

  def last_communication_at
    last_message_at = messages.latest.first&.created_at
    last_call_at = calls.latest.first&.created_at

    if last_message_at.to_i > last_call_at.to_i
      last_message_at
    else
      last_call_at
    end
  end

  def receive_incoming_call(from:, sid:, **)
    receiving_number = if should_be_screened?(from)
      screener_number
    else
      number
    end

    ReceiveCall.new(to: receiving_number, from: from, sid: sid).call
  end

  def receive_transfer_request_call(transfer_request:, from:, sid:)
    ReceiveTransferRequestCall.new(transfer_request: transfer_request, to: number, from: from, sid: sid).call
  end

  def update_availability(available: self.available, availability_note: self.availability_note)
    update(available: available, availability_note: availability_note).tap do
      if valid? && !available?
        ring_group_memberships.available.each { |membership| membership.update(available: false) }
      end
    end
  end

  def abilities
    @abilities ||= []
  end

  def abilities=(abilities)
    @abilities = abilities.map { |ability| ability.downcase.to_sym }
  end

  def can?(action)
    abilities.include?(action.downcase.to_sym)
  end

  private

  def caller_id
    caller_id_number.presence || phone_number
  end

  def should_be_screened?(incoming_number)
    screener_number&.available? && PhoneNumber.external?(incoming_number)
  end

  def broadcast_availability
    BroadcastUserAvailabilityJob.perform_later(id) if availability_changed?
  end

  def availability_changed?
    previous_changes.key?(:available) || previous_changes.key?(:availability_note)
  end
end
