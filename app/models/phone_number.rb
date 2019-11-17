class PhoneNumber < ApplicationRecord
  PING_DATE = 7.days

  belongs_to :assignable, polymorphic: true, optional: true
  belongs_to :user,
    foreign_key: :assignable_id,
    foreign_type: :assignable_type,
    class_name: "User",
    polymorphic: true,
    optional: true
  belongs_to :ring_group,
    foreign_key: :assignable_id,
    foreign_type: :assignable_type,
    class_name: "RingGroup",
    polymorphic: true,
    optional: true

  validates :number, presence: true, uniqueness: true
  validates :assignable_id,
    uniqueness: {scope: :assignable_type},
    allow_nil: true,
    if: -> { !forwarding }

  after_commit :reindex_assignable

  scope :unassigned, -> { where(assignable: nil) }
  scope :forwarding, ->(forwarding = true) { where(forwarding: forwarding) }

  delegate :available?, to: :assignable
  delegate :last_communication_at, to: :assignable

  def self.send_ping_messages
    find_each do |number|
      if PING_DATE.ago.to_i > number.last_communication_at.to_i
        SendPingMessageJob.perform_later(number)
      end
    end
  end

  def self.external?(phone_number)
    !exists?(number: phone_number)
  end

  def forward_to(user)
    update(assignable: user, forwarding: true)
  end

  def receive_incoming_call(from:, sid:)
    assignable.receive_incoming_call(to: self, from: from, sid: sid)
  end

  def receive_transfer_request_call(transfer_request:, from:, sid:)
    assignable.receive_transfer_request_call(
      transfer_request: transfer_request,
      from: from,
      sid: sid
    )
  end

  def assignable
    super || Unassigned.new
  end

  private

  def reindex_assignable
    if assignable.present? && assignable.respond_to?(:reindex)
      assignable.reindex
    end
  end
end
