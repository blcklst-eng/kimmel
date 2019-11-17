require "rails_helper"

describe "Conversations Query API", :graphql do
  describe "conversations" do
    let(:query) do
      <<~'GRAPHQL'
        query {
          conversations {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets conversations involving the current user" do
      user = create(:user)
      conversation = create(:conversation, user: user)

      result = execute query, as: user

      nodes = result[:data][:conversations][:edges].pluck(:node)
      expect(nodes).to include(id: conversation.id.to_s)
    end
  end
end
