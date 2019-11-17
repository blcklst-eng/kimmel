module Outputs
  class ConversationType < Types::BaseObject
    implements Types::ActiveRecord

    field :read, Boolean, null: false
    field :user, UserType, null: false
    field :contact, ContactType, null: false
    field :messages, MessageType.connection_type, null: false
    field :most_recent_message, MessageType, null: false

    def user
      Loaders::AssociationLoader.for(Conversation, :user).load(@object)
    end

    def contact
      Loaders::AssociationLoader.for(Conversation, :contact).load(@object)
    end

    def messages(input: nil)
      Loaders::AssociationLoader.for(Conversation, :messages).load(@object)
    end

    def most_recent_message
      Loaders::AssociationLoader.for(Conversation, :most_recent_message).load(@object)
    end
  end
end
