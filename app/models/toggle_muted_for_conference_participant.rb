class ToggleMutedForConferenceParticipant
  def initialize(participant, adapter: TwilioAdapter.new)
    @participant = participant

    @adapter = adapter
  end

  def call
    result = update_conference_participant

    if result
      participant.toggle(:muted).save
      Result.success(participant: participant)
    else
      Result.failure("Failed to update the conference participant")
    end
  end

  private

  attr_reader :participant, :mute, :adapter

  def update_conference_participant
    call = participant.call
    adapter.update_conference_participant(
      call.conference_sid,
      participant.sid,
      params: {muted: !participant.muted?}
    )
  end
end
