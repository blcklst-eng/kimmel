class NotifyTransferRequestUser
  def initialize(transfer_request)
    @transfer_request = transfer_request
  end

  def call
    if transfer_request.should_ask?
      broadcast_transfer_request
      Result.success(transfer_request: transfer_request)
    else
      make_call
    end
  end

  private

  attr_reader :transfer_request

  def make_call
    CreateTransferRequestCall.new(transfer_request).call
  end

  def broadcast_transfer_request
    BroadcastTransferRequestJob.perform_later(transfer_request)
  end
end
