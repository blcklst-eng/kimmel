require "rails_helper"

describe "Search Contacts Query API", :graphql, :search do
  describe "searchContacts" do
    let(:query) do
      <<~'GRAPHQL'
        query($query: String!) {
          searchContacts(query: $query) {
            id
          }
        }
      GRAPHQL
    end

    it "gets contacts matching the provided query" do
      user = create(:user)
      first = create(:contact, user: user, first_name: "John", last_name: "Doe")
      second = create(:contact, user: user, first_name: "Alan", last_name: "Smith")
      reindex_search(Contact)

      result = execute query, as: user, variables: {query: "doe"}

      contacts = result[:data][:searchContacts]
      expect(contacts).to include(id: first.id.to_s)
      expect(contacts).not_to include(id: second.id.to_s)
    end
  end
end
