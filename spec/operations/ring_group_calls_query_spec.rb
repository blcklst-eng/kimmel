require "rails_helper"

describe "Ring Group Calls Query API", :graphql do
  describe "ringGroupCalls" do
    let(:query) do
      <<-'GRAPHQL'
        query($ringGroupId: ID!) {
          ringGroupCalls(ringGroupId: $ringGroupId) {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets all ring group calls for the specified ring group" do
      user = create(:user)
      ring_group = create(:ring_group, users: [user])
      call = create(:ring_group_call, ring_group: ring_group)

      result = execute query, as: user, variables: {
        ringGroupId: ring_group.id,
      }

      nodes = result[:data][:ringGroupCalls][:edges].pluck(:node)
      expect(nodes).to include(id: call.id.to_s)
    end
  end
end
