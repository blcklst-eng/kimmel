class Recording < ApplicationRecord
  belongs_to :call
  has_one :user, through: :call
  has_one_attached :audio

  validates :sid, presence: true, uniqueness: true
  validates :duration, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
  }
  validate :audio?

  scope :for_user, ->(user) { joins(:call).merge(Call.for_user(user)) }
  scope :recorded, -> { joins(:call).merge(Call.recorded) }

  delegate :recorded?, to: :call

  private

  def audio?
    errors.add(:base, "Audio file required") unless audio.attached?
  end
end
