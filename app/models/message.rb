class Message < ApplicationRecord
  include Filterable

  belongs_to :conversation, touch: :last_message_at
  has_many_attached :media

  validates :body, presence: true, unless: -> { media.attached? }

  after_commit :broadcast_message, :notify_walter, on: :create

  searchkick callbacks: :async

  scope :since, ->(date) {
    where("created_at >= ?", date)
  }

  scope :prior_to, ->(date) {
    where("created_at <= ?", date)
  }

  delegate :user, to: :conversation
  delegate :user_id, to: :conversation
  delegate :contact, to: :conversation

  def search_data
    {user_id: conversation.user_id, body: body}
  end

  def status_url
    RouteHelper.message_status_url(self)
  end

  def attach_remote_media(urls)
    Array.wrap(urls).map do |url|
      result = DownloadFile.new.from_url(url)
      next unless result.success?

      media.attach(
        io: result.file,
        filename: "#{SecureRandom.hex}#{result.extension}"
      )
    end
  end

  private

  def broadcast_message
    BroadcastMessageJob.perform_later(id)
  end

  def notify_walter
    WalterMessageNotificationJob.perform_later(self)
  end
end
