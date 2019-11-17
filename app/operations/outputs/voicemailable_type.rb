module Outputs
  class VoicemailableType < Types::BaseUnion
    description "Objects which may have a voicemail"
    possible_types IncomingCallType, RingGroupCallType

    def self.resolve_type(object, _context)
      if object.is_a?(IncomingCall)
        IncomingCallType
      elsif object.is_a?(RingGroupCall)
        RingGroupCallType
      else
        raise "Unexpected VoicemailableType: #{object.inspect}"
      end
    end
  end
end
