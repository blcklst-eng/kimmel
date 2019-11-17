class BuildConferenceEvent
  MAP = {
    "participant-join" => ConferenceEvents::ParticipantJoin,
    "participant-leave" => ConferenceEvents::ParticipantLeave,
    "conference-start" => ConferenceEvents::ConferenceStart,
    "conference-end" => ConferenceEvents::ConferenceEnd,
  }.freeze

  def self.from(params)
    MAP.fetch(params[:event], ConferenceEvents::UnknownEvent).new(params)
  end
end
