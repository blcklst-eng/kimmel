module Outputs
  class ParticipantType < Types::BaseObject
    implements Types::ActiveRecord

    field :call, CallType, null: false
    field :contact, ContactType, null: false
    field :sid, String, null: true
    field :status, Types::ParticipantStatusType, null: false
    field :on_hold, Boolean, null: false
    field :muted, Boolean, null: false
    field :transfer_request, TransferRequestType, null: true

    def call
      Loaders::AssociationLoader.for(Participant, :call).load(@object)
    end

    def contact
      Loaders::AssociationLoader.for(Participant, :contact).load(@object)
    end

    def transfer_request
      Loaders::AssociationLoader.for(Participant, :transfer_request).load(@object)
    end
  end
end
