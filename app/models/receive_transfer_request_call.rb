class ReceiveTransferRequestCall
  def initialize(transfer_request:, to:, from:, sid:)
    @transfer_request = transfer_request
    @to = to
    @from = from
    @sid = sid
  end

  def call
    result = ReceiveCall.new(to: to, from: from, sid: sid).call
    return result unless result.success?

    if transfer_request.update(request_call: result.call)
      result
    else
      Result.failure("Failed to update transfer request call")
    end
  end

  attr_reader :transfer_request, :to, :from, :sid
end
