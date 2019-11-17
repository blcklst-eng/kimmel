require "rails_helper"

describe "Unread Conversations Query API", :graphql do
  describe "unreadConversations" do
    let(:query) do
      <<~'GRAPHQL'
        query {
          unreadConversations {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets all unread conversations involving the current user" do
      user = create(:user)
      conversation = create(:conversation, :unread, user: user)

      result = execute query, as: user

      nodes = result[:data][:unreadConversations][:edges].pluck(:node)
      expect(nodes).to include(id: conversation.id.to_s)
    end
  end
end
