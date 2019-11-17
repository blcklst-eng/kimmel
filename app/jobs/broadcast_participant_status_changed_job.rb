class BroadcastParticipantStatusChangedJob < ApplicationJob
  queue_as :default

  def perform(participant_id)
    participant = Participant.find(participant_id)
    MessagingSchema.subscriptions.trigger(
      "participantStatusChanged",
      {participant_id: participant_id},
      participant
    )
  end
end
