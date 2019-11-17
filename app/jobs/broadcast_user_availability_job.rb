class BroadcastUserAvailabilityJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    trigger_subscription(user)
  end

  private

  def trigger_subscription(user)
    MessagingSchema.subscriptions.trigger("userAvailability", {}, user)
  end
end
