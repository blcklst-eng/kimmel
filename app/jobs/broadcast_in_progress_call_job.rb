class BroadcastInProgressCallJob < ApplicationJob
  queue_as :default

  def perform(call_id)
    call = Call.find(call_id)
    trigger_globally(call)
    trigger_to_user(call)
  end

  private

  def trigger_globally(call)
    trigger(call)
  end

  def trigger_to_user(call)
    trigger(call, user_id: call.user_id)
  end

  def trigger(call, args = {})
    MessagingSchema.subscriptions.trigger("ongoingCall", args, call)
  end
end
