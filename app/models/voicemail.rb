class Voicemail < ApplicationRecord
  include Filterable

  EXPIRES = 30.days.freeze

  belongs_to :voicemailable, polymorphic: true
  has_one_attached :audio

  validate :audio?
  validates :sid, presence: true

  after_commit :broadcast_counts, on: [:create, :destroy]

  scope :expired, -> { archived(false).where("created_at <= ?", Time.current - EXPIRES) }
  scope :not_viewed, -> { where(viewed: false) }
  scope :archived, ->(is_archived = true) { where(archived: is_archived) }

  delegate :owner?, to: :voicemailable

  delegate :email_voicemails?, to: :voicemailable

  def self.delete_expired
    expired.find_each(&:destroy)
  end

  def expiration
    return nil if archived?

    created_at + EXPIRES
  end

  def view
    transaction { update(viewed: true) }
      .tap { |result| broadcast_counts if result }
  end

  private

  def audio?
    errors.add(:base, "Audio file required") unless audio.attached?
  end

  def broadcast_counts
    BroadcastCountsJob.perform_later(voicemailable.user_id) if voicemailable.is_a?(IncomingCall)
  end
end
