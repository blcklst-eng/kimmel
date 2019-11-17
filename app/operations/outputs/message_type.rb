module Outputs
  module MessageType
    include Types::BaseInterface
    include Types::ActiveRecord

    field :body, String, null: true
    field :status, Types::MessageStatusType, null: false
    field :conversation, ConversationType, null: false
    field :media, [MessageMediaType], null: false

    def conversation
      Loaders::AssociationLoader.for(Message, :conversation).load(@object)
    end

    def media
      Loaders::AssociationLoader.for(Message, :media_blobs).load(@object).then do
        @object.media
      end
    end

    orphan_types IncomingMessageType, OutgoingMessageType

    definition_methods do
      def resolve_type(object, _context)
        if object.is_a?(OutgoingMessage)
          OutgoingMessageType
        elsif object.is_a?(IncomingMessage)
          IncomingMessageType
        else
          raise "Unexpected MessageType: #{object.inspect}"
        end
      end
    end
  end
end
