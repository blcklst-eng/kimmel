require "rails_helper"

describe "Read Conversation Mutation API", :graphql do
  describe "readConversation" do
    let(:query) do
      <<~'GRAPHQL'
        mutation($input: ReadConversationInput!) {
          readConversation(input: $input) {
            conversation {
              read
            }
          }
        }
      GRAPHQL
    end

    it "marks a conversation as read" do
      user = create(:user_with_number)
      conversation = create(:conversation, :unread, user: user)

      result = execute query, as: user, variables: {
        input: {
          id: conversation.id,
        },
      }

      read = result[:data][:readConversation][:conversation][:read]
      expect(read).to be(true)
      expect(conversation.reload.read).to be(true)
    end
  end
end
