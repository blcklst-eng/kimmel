class CreateTransferRequestCall
  def initialize(transfer_request, adapter: TwilioAdapter.new)
    @transfer_request = transfer_request

    @adapter = adapter
  end

  def call
    result = adapter.create_call(create_call_args)

    if result.connected?
      Result.success(transfer_request: transfer_request)
    else
      Result.failure("Failed to create call")
    end
  end

  private

  attr_reader :transfer_request, :adapter

  def create_call_args
    {
      url: RouteHelper.transfer_request_call_url(transfer_request.id),
      to: transfer_request.requestor.incoming_connection,
      from: transfer_request.requestor.client,
    }
  end
end
