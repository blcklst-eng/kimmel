require "rails_helper"

describe "Generate Call Token Mutation API", :graphql do
  describe "generateCallToken" do
    let(:query) do
      <<~'GRAPHQL'
        query {
          callToken
        }
      GRAPHQL
    end

    it "get a token that gives the capability to take incoming and outgoing calls" do
      user = create(:user)

      result = execute query, as: user

      token = result[:data][:callToken]
      expect(token).not_to be(nil)
    end
  end
end
