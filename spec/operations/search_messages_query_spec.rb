require "rails_helper"

describe "Search Messages Query API", :graphql, :search do
  describe "searchMessages" do
    let(:query) do
      <<~'GRAPHQL'
        query($query: String!) {
          searchMessages(query: $query) {
            id
          }
        }
      GRAPHQL
    end

    it "gets messages matching the provided query" do
      user = create(:user)
      conversation = create(:conversation, user: user)
      first = create(:incoming_message, body: "First message", conversation: conversation)
      second = create(:incoming_message, body: "Second message", conversation: conversation)
      reindex_search(Message)

      result = execute query, as: user, variables: {query: "first"}

      messages = result[:data][:searchMessages]
      expect(messages).to include(id: first.id.to_s)
      expect(messages).not_to include(id: second.id.to_s)
    end
  end
end
