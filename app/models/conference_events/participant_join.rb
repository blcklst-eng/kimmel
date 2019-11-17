module ConferenceEvents
  class ParticipantJoin
    def initialize(sid:, conference_sid:, **)
      @sid = sid
      @conference_sid = conference_sid
    end

    def apply(call)
      call.transition_to(:in_progress) unless call.in_state?(:in_progress)
      call.update(conference_sid: conference_sid) unless call.conference_sid
      call.participants.where(sid: sid).update(status: :in_progress)
    end

    private

    attr_accessor :sid, :conference_sid
  end
end
