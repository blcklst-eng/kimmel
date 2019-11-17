class MakeCall
  def initialize(to:, from:, sid:, adapter: TwilioAdapter.new)
    @to = to
    @user = user_from_client(from)
    @sid = sid
    @adapter = adapter
  end

  def call
    return Result.failure("Invalid from number") unless user
    return invalid_phone_number_response unless lookup.valid?

    call = OutgoingCall.make(user: user, to: lookup.phone_number, sid: sid)
    connect(call)
  end

  private

  attr_reader :user, :to, :sid, :adapter

  def user_from_client(from)
    identifier = from[/\d+/]
    User.find_by(id: identifier)
  end

  def connect(call)
    result = connect_participant_to_call(call)

    if result.success?
      call.original_participant.update(sid: result.sid)
      call.transition_to(:initiated)
      queue_call_response(call)
    else
      call.transition_to(:failed)
      invalid_phone_number_response
    end
  end

  def connect_participant_to_call(call)
    ConnectCall.new(
      call: call,
      to: lookup.phone_number,
      from: user.outgoing_number(call)
    ).call
  end

  def lookup
    @lookup ||= adapter.lookup(to)
  end

  def invalid_phone_number_response
    Result.success(response: InvalidPhoneNumberResponse.new.to_s)
  end

  def queue_call_response(call)
    Result.success(response: QueueCallResponse.new(call: call).to_s)
  end
end
