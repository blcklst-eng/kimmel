class IncomingMessage < Message
  enum status: {delivered: 0}

  after_commit :touch_contact, :publish_push_notifications, on: :create

  def to
    conversation.user_phone_number
  end

  def from
    conversation.contact_phone_number
  end

  def update_status(_status_object)
    self
  end

  private

  def touch_contact
    contact.update(last_contact_at: Time.current)
  end

  def publish_push_notifications
    PublishPushNotificationForMessageJob.perform_later(id)
  end
end
