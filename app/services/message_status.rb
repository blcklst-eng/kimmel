MessageStatus = Struct.new(:message_status) {
  def delivered?
    message_status == "delivered"
  end

  def failed?
    message_status.in? %w[failed undelivered]
  end
}
