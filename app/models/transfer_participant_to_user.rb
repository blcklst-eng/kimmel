class TransferParticipantToUser
  def initialize(participant:, user:, adapter: TwilioAdapter.new)
    @participant = participant
    @user = user

    @adapter = adapter
  end

  def call
    result = adapter.update_call(update_call_args)

    if result
      Result.success
    else
      Result.failure("Failed to update the call")
    end
  end

  private

  attr_reader :participant, :user, :adapter

  def update_call_args
    {
      sid: participant.sid,
      url: transfer_url,
    }
  end

  def transfer_url
    RouteHelper.transfer_participant_url(
      to: user.phone_number,
      from: participant.phone_number
    )
  end
end
