class BroadcastMessageJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    TriggerMessageSubscriptions.new(message).call
  end
end
