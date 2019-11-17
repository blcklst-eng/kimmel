require "rails_helper"

describe "Toggle Call Forwarding Muation API", :graphql do
  describe "toggleCallForwarding" do
    let(:query) do
      <<-'GRAPHQL'
        mutation {
          toggleCallForwarding(input: {}) {
            user {
              callForwarding
            }
          }
        }
      GRAPHQL
    end

    it "toggles call forwarding for the current user" do
      user = create(:user, call_forwarding_number: "+18882552550", call_forwarding: false)

      execute query, as: user

      user.reload
      expect(user.call_forwarding).to eq(true)
    end
  end
end
