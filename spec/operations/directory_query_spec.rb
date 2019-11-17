require "rails_helper"

describe "Directory Query API", :graphql do
  describe "directory" do
    let(:query) do
      <<-'GRAPHQL'
        query {
          directory {
            edges {
              node {
                id
              }
            }
          }
        }
      GRAPHQL
    end

    it "returns a list of users" do
      user = create(:user_with_number)

      result = execute query, as: user

      directory = result[:data][:directory][:edges].pluck(:node)
      expect(directory).to include(id: user.id.to_s)
    end
  end
end
