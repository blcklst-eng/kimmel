class Participant < ApplicationRecord
  enum status: {
    initiated: 0,
    in_progress: 1,
    completed: 2,
  }

  has_one :transfer_request, required: false, dependent: :restrict_with_error

  belongs_to :contact
  belongs_to :call
  belongs_to :incoming_call,
    class_name: "IncomingCall",
    foreign_key: "call_id",
    optional: true,
    inverse_of: :participants

  validates :status, presence: true
  validates_associated :contact

  after_commit :touch_contact, on: :create
  after_commit :broadcast_status_changed

  scope :active, -> { initiated.or(in_progress) }

  delegate :phone_number, :internal?, to: :contact

  private

  def touch_contact
    contact.update(last_contact_at: Time.current) if call.is_a?(IncomingCall)
  end

  def broadcast_status_changed
    BroadcastParticipantStatusChangedJob.perform_later(id) if previous_changes.key?(:status)
  end
end
