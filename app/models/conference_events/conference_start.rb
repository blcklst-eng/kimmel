module ConferenceEvents
  class ConferenceStart
    def initialize(params)
      @conference_sid = params[:conference_sid]
    end

    def apply(call)
      call.transition_to(:in_progress) unless call.in_state?(:in_progress)
      call.update(conference_sid: conference_sid) unless call.conference_sid
    end

    private

    attr_reader :conference_sid
  end
end
