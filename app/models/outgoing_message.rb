class OutgoingMessage < Message
  enum status: {sent: 0, delivered: 1, failed: 2}

  def from
    conversation.user_phone_number
  end

  def to
    conversation.contact_phone_number
  end

  def update_status(status_object)
    case status_object
    when :delivered?.to_proc
      delivered!
      BroadcastMessageStatusChangedJob.perform_later(id)
    when :failed?.to_proc
      failed!
      BroadcastMessageStatusChangedJob.perform_later(id)
    end
    self
  end
end
