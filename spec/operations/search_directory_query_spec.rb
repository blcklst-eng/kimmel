require "rails_helper"

describe "Search Directory Query API", :graphql, :search do
  describe "searchDirectory" do
    let(:query) do
      <<-'GRAPHQL'
        query($query: String!) {
          searchDirectory(query: $query) {
            id
          }
        }
      GRAPHQL
    end

    it "returns results of users" do
      user = create(:user)
      search_user = create(:user_with_number, first_name: "john")
      reindex_search(User)

      results = execute query, as: user, variables: {
        query: "john",
      }

      directory = results[:data][:searchDirectory]
      expect(directory).to include(id: search_user.id.to_s)
    end
  end
end
