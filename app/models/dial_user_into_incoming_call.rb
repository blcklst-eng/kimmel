class DialUserIntoIncomingCall
  def initialize(call)
    @incoming_call = call
    @user = call.user
  end

  def call
    result = connect(incoming_call)

    if result.success?
      incoming_call.transition_to(:initiated)
      incoming_call.update(sid: result.sid)
      Result.success(call: incoming_call)
    else
      incoming_call.transition_to(:failed)
      Result.failure("Call could not be connected")
    end
  end

  private

  attr_reader :incoming_call, :user

  def connect(incoming_call)
    ConnectCall.new(
      call: incoming_call,
      to: user.incoming_connection,
      from: incoming_call.from_phone_number
    ).call
  end
end
