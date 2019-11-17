class ConnectCall
  def initialize(call:, to:, from:, adapter: TwilioAdapter.new)
    @connecting_call = call
    @to = to
    @from = from
    @adapter = adapter
  end

  def call
    result = adapter.create_call(options)

    if result.connected?
      Result.success(sid: result.sid)
    else
      Result.failure("Could not connect to user")
    end
  end

  private

  attr_reader :connecting_call, :to, :from, :adapter

  def options
    {
      to: to,
      from: from,
      url: RouteHelper.connect_to_conference_url(connecting_call),
      status_callback: RouteHelper.route_call_url(connecting_call),
      status_callback_event: %w[answered completed],
      timeout: connecting_call.class::RING_TIMEOUT,
    }
  end
end
