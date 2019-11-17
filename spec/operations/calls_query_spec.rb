require "rails_helper"

describe "Calls Query API", :graphql do
  describe "calls" do
    let(:query) do
      <<-'GRAPHQL'
        query($missed: Boolean) {
          calls(missed: $missed) {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "gets all calls for the user" do
      user = create(:user)
      call = create(:incoming_call, user: user)

      result = execute query, as: user

      nodes = result[:data][:calls][:edges].pluck(:node)
      expect(nodes).to include(id: call.id.to_s)
    end

    it "gets missed calls for the user" do
      user = create(:user)
      missed_call = create(:incoming_call, :no_answer, user: user)
      completed_call = create(:incoming_call, :completed, user: user)

      result = execute query, as: user, variables: {
        missed: true,
      }

      nodes = result[:data][:calls][:edges].pluck(:node)
      expect(nodes).to include(id: missed_call.id.to_s)
      expect(nodes).not_to include(id: completed_call.id.to_s)
    end
  end
end
