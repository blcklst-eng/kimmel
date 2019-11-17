class RingGroupMember < ApplicationRecord
  belongs_to :user
  belongs_to :ring_group

  validates :available, exclusion: {
    in: [true],
    if: -> { !user&.available? },
    message: "user must be available",
  }

  after_commit :broadcast_availability

  delegate :phone_number, to: :user

  scope :available, -> { where(available: true) }

  private

  def broadcast_availability
    BroadcastRingGroupMemberAvailabilityJob.perform_later(id) if previous_changes.key?(:available)
  end
end
