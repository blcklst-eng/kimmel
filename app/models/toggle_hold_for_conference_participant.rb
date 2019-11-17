class ToggleHoldForConferenceParticipant
  def initialize(participant, adapter: TwilioAdapter.new)
    @participant = participant

    @adapter = adapter
  end

  def call
    result = update_conference_participant

    if result
      participant.toggle(:on_hold).save
      Result.success(participant: participant)
    else
      Result.failure("Failed to update the conference participant")
    end
  end

  private

  attr_reader :participant, :adapter

  def update_conference_participant
    call = participant.call
    adapter.update_conference_participant(
      call.conference_sid,
      participant.sid,
      params: {hold: !participant.on_hold?}
    )
  end
end
