module Outputs
  class IncomingCallType < Types::BaseObject
    implements CallType

    field :voicemail, VoicemailType, null: true
    field :transfer_request, TransferRequestType, null: true
    field :ring_group_call, RingGroupCallType, null: true

    def voicemail
      Loaders::AssociationLoader.for(IncomingCall, :voicemail).load(@object)
    end

    def transfer_request
      Loaders::AssociationLoader.for(IncomingCall, :transfer_request).load(@object)
    end

    def ring_group_call
      Loaders::AssociationLoader.for(IncomingCall, :ring_group_call).load(@object)
    end
  end
end
