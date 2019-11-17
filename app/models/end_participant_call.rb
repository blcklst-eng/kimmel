class EndParticipantCall
  def initialize(participant, adapter: TwilioAdapter.new)
    @participant = participant
    @adapter = adapter
  end

  def call
    return Result.failure("Cannot end a call that is not active") if participant.completed?

    if adapter.end_call(participant.sid)
      participant.completed!
      Result.success(participant: participant)
    else
      Result.failure("Failed to end call")
    end
  end

  private

  attr_reader :participant, :adapter
end
