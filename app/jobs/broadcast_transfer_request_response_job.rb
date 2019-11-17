class BroadcastTransferRequestResponseJob < ApplicationJob
  queue_as :default

  def perform(transfer_request)
    trigger_subscription(transfer_request)
  end

  private

  def trigger_subscription(transfer_request)
    MessagingSchema.subscriptions.trigger(
      "transferRequest",
      {},
      transfer_request,
      scope: transfer_request.requestor.id
    )
  end
end
