class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :contact
  has_many :messages, -> { latest }, inverse_of: :conversation, dependent: :restrict_with_error
  has_one :most_recent_message,
    -> { latest },
    class_name: "Message",
    inverse_of: false

  scope :for_user, ->(user) { where(user: user) }
  scope :unread, -> { where(read: false) }
  scope :order_by_most_recent_message, -> { order(last_message_at: :desc) }
  scope :with_contact_phone_number, ->(phone_number) do
    joins(:contact).merge(Contact.where(phone_number: phone_number))
  end

  delegate :phone_number, to: :user, prefix: true
  delegate :phone_number, to: :contact, prefix: true

  def read_messages
    transaction { update(read: true) }
      .tap { |result| BroadcastCountsJob.perform_later(user_id) if result }
  end

  def message_received
    transaction { update(read: false) }
      .tap { |result| BroadcastCountsJob.perform_later(user.id) if result }
  end

  def self.unread_count
    unread.count
  end
end
