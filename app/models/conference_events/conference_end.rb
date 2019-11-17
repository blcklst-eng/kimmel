module ConferenceEvents
  class ConferenceEnd
    def initialize(*)
    end

    def apply(call)
      EndCall.new(call).call
    end
  end
end
