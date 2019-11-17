class RejoinCall
  def initialize(call:, user:, adapter: TwilioAdapter.new)
    @call_to_join = call
    @user = user
    @adapter = adapter
  end

  def call
    return Result.failure("Only active calls can be joined") unless call_to_join.active?

    result = adapter.create_call(call_options)

    if result.connected?
      call_to_join.update(sid: result.sid)
      Result.success(call: call_to_join)
    else
      Result.failure("Failed to join call")
    end
  end

  private

  attr_reader :call_to_join, :user, :adapter

  def call_options
    {
      to: user.incoming_connection,
      from: user.client,
      url: RouteHelper.connect_to_conference_url(call_to_join),
    }
  end
end
