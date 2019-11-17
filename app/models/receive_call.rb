class ReceiveCall
  def initialize(to:, from:, sid:)
    @user = to.user
    @from = from
    @sid = sid
  end

  def call
    return Result.failure("Invalid to number") unless user

    call = IncomingCall.receive(user: user, from: from, sid: sid)

    if user.available?
      connect_user_to_call(call)
    else
      voicemail_response(call)
    end
  end

  private

  attr_reader :user, :from, :sid

  def connect_user_to_call(call)
    result = DialUserIntoIncomingCall.new(call).call

    if result.success?
      Result.success(response: response(result.call), call: result.call)
    else
      result
    end
  end

  def voicemail_response(call)
    call.transition_to(:no_answer)
    Result.success(response: VoicemailResponse.new(call).to_s)
  end

  def response(call)
    QueueCallResponse.new(call: call).to_s
  end
end
