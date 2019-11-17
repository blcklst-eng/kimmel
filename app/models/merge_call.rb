class MergeCall
  def initialize(from:, to:)
    @from = from
    @to = to
  end

  def call
    result = ConnectCallToConference.new(call: to, sids: participants_to_merge.map(&:sid)).call
    connected_participants = participants_to_merge.where(sid: result.connected)

    if result.success?
      from.transition_to(:completed)
      Result.success(
        participants: create_participants(connected_participants),
        failed_participants: []
      )
    else
      Result.failure(
        result.errors,
        participants: connected_participants,
        failed_participants: participants_to_merge - connected_participants
      )
    end
  end

  private

  attr_reader :to, :from

  def participants_to_merge
    @participants_to_merge ||= from.participants.active
  end

  def create_participants(connected_participants)
    connected_participants.map do |participant|
      to.add_participant(phone_number: participant.phone_number, sid: participant.sid)
    end
  end
end
