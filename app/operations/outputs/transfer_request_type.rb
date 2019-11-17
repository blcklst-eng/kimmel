module Outputs
  class TransferRequestType < Types::BaseObject
    implements Types::ActiveRecord

    field :participant, ParticipantType, null: false
    field :receiver, UserType, null: false
    field :response, String, null: false
    field :contact, ContactType, null: false

    def participant
      Loaders::AssociationLoader.for(TransferRequest, :participant).load(@object)
    end

    def receiver
      Loaders::AssociationLoader.for(TransferRequest, :receiver).load(@object)
    end

    def requestor
      Loaders::AssocationLoader.for(TransferRequest, :requestor).load(@object)
    end

    def contact
      Loaders::AssocationLoader.for(TransferRequest, :contact).load(@object)
    end
  end
end
