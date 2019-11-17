module Outputs
  class CountsType < Types::BaseObject
    field :missed_calls, Integer, null: false
    field :new_voicemails, Integer, null: false
    field :unread_conversations, Integer, null: false

    def missed_calls
      Call.for_user(@object).not_viewed.count
    end

    def new_voicemails
      @object.voicemails.not_viewed.count
    end

    def unread_conversations
      Conversation.for_user(@object).unread.count
    end
  end
end
