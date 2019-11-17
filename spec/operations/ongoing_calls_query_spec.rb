require "rails_helper"

describe "Ongoing Calls Query API", :graphql do
  describe "ongoingCalls" do
    let(:query) do
      <<-'GRAPHQL'
        query {
          ongoingCalls {
            id
          }
        }
      GRAPHQL
    end

    it "gets all ongoing calls for the user" do
      user = create(:user)
      call = create(:incoming_call, :in_progress, user: user)

      result = execute query, as: user

      calls = result[:data][:ongoingCalls]
      expect(calls).to include(id: call.id.to_s)
    end
  end
end
