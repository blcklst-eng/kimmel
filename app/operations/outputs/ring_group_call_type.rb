module Outputs
  class RingGroupCallType < Types::BaseObject
    implements Types::ActiveRecord

    field :ring_group, RingGroupType, null: false
    field :voicemail, VoicemailType, null: true
    field :answered_call, IncomingCallType, null: true
    field :from_sid, String, null: false
    field :from_phone_number, String, null: false
    field :missed, Boolean, null: false

    def ring_group
      Loaders::AssociationLoader.for(RingGroupCall, :ring_group).load(@object)
    end

    def voicemail
      Loaders::AssociationLoader.for(RingGroupCall, :voicemail).load(@object)
    end

    def answered_call
      Loaders::AssociationLoader.for(RingGroupCall, :answered_call).load(@object)
    end
  end
end
