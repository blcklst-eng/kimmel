class BroadcastCountsJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    MessagingSchema.subscriptions.trigger("counts", {}, user, scope: user_id)
  end
end
