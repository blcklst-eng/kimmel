module ConferenceEvents
  class ParticipantLeave
    def initialize(sid:, **)
      @sid = sid
    end

    def apply(call)
      call.participants.find_by(sid: sid)&.completed!
      EndCall.new(call).call unless call.active_participants?
    end

    private

    attr_accessor :sid
  end
end
